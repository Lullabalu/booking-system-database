
-- 1) Полная информация о бронированиях
create view campus.booking_full as
select 
  b.booking_id,
  u.user_id,
  u.full_name,
  u.role,
  r.room_id,
  r.room_number,
  bu.building_id,
  bu.name as building_name,
  p.purpose_id,
  p.purpose_name,
  b.start_at,
  b.end_at,
  b.status
from campus.booking b
join campus.users u on u.user_id = b.user_id
join campus.room r on r.room_id = b.room_id
join campus.building bu on bu.building_id = r.building_id
join campus.purpose p on p.purpose_id = b.purpose_id;


-- 2) Активные бронирования
create view campus.active_bookings as
select * from
campus.booking_full where status = 'active';

-- 3) Бронирования с их длительностью
create view campus.booking_duration as
select 
  b.booking_id,
  b.user_id,
  b.room_id,
  b.purpose_id,
  b.start_at,
  b.end_at,
  b.status,
  b.end_at - b.start_at as duration
from campus.booking b;

-- 4) Количество бронирований по пользователям
create view campus.user_booking_count as
select 
  u.user_id,
  u.full_name,
  u.role,
  COALESCE(count(b.booking_id), 0) as booking_count
from campus.users u
left join campus.booking b
  on u.user_id = b.user_id
group by 
  u.user_id