-- 1) Процедура очистки старых бронирований
create or replace procedure campus.cleanup_bookings(t timestamp)
language plpgsql
as $$
begin
    delete from campus.booking
    where end_at < t;
end;
$$;

-- 2) Проверка свободна ли аудитория на конкретное время
create or replace function campus.room_available(
    room_id int,
    start_at timestamp,
    end_at timestamp
)
returns boolean
language sql
as $$
    select not exists (
        select 1
        from campus.booking b
        where b.room_id = room_id
          and b.start_at < end_at and b.end_at > start_at
    );
$$;

-- 3) Создание брони только если аудитория свободна
create or replace procedure campus.create_booking_if_available(
    user_id int,
    room_id int,
    start_at timestamp,
    end_at timestamp,
    purpose_id int
)
language plpgsql
as $$
begin
    if end_at <= start_at then
        raise exception 'Конец должен быть позже начала';
    end if;

    if not campus.room_available(room_id, start_at, end_at) then
        raise exception 'Комната % не полностью свободна с % по %',
            room_id, start_at, end_at;
    end if;

    insert into campus.booking (
        user_id,
        room_id,
        start_at,
        end_at,
        purpose_id
    )
    values (
        user_id,
        room_id,
        start_at,
        end_at,
        purpose_id
    );
end;
$$;

-- 4) Длительность бронирования
create or replace function campus.booking_duration(
    booking_id int
)
returns interval
language sql
as $$
    select b.end_at - b.start_at
    from campus.booking b
    where b.booking_id = booking_id;
$$;