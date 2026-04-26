-- 1) Проверка пересечения
create or replace function campus.check_booking_conflict()
returns trigger
language plpgsql
as $$
begin
    if exists (
        select 1
        from campus.booking b
        where b.room_id = new.room_id
          and b.booking_id != new.booking_id
          and b.start_at < new.end_at
          and b.end_at > new.start_at
    ) then
        raise exception 'Конфликт бронирования для комнаты %', new.room_id;
    end if;

    return new;
end;
$$;

create trigger trg_check_booking_conflict
before insert or update on campus.booking
for each row
execute function campus.check_booking_conflict();


-- 2) Запрет на бронирование в прошлом
create or replace function campus.past_booking()
returns trigger
language plpgsql
as $$
begin
    if new.start_at < now() then
        raise exception 'Нельзя создать бронь в прошлом';
    end if;

    return new;
end;
$$;


create trigger trg_past_booking
before insert or update on campus.booking
for each row
execute function campus.past_booking();

-- 3) Запрет изменения прошедших броней
create or replace function campus.update_past_booking()
returns trigger
language plpgsql
as $$
begin
    if old.end_at < now() then
        raise exception 'Нельзя изменять уже завершённые бронирования';
    end if;

    return new;
end;
$$;

create trigger trg_update_past_booking
before update on campus.booking
for each row
execute function campus.update_past_booking();