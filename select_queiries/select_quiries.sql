-- 1) Все активные брони семинаристов
select b.booking_id,
    u.full_name as seminarist_name,
    bu.building_name,
    r.room_number,
    p.purpose_name,
    b.start_at,
    b.end_at,
    b.status
from campus.booking b
join campus.users u
    on b.user_id = u.user_id
join campus.room r
    on b.room_id = r.room_id
join campus.building bu
    on r.building_id = bu.building_id
join campus.purpose p
    on b.purpose_id = p.purpose_id
where u.role = 'seminarist'
  and b.status = 'active'
order by b.start_at;


-- 2) Количество семинарских аудиторий с вместимостью >= 25
select bu.building_name,
    COUNT(r.room_id) AS room_count
from campus.building bu
left join campus.room r
	on bu.building_id = r.building_id
where r.type = 'seminar'
	and r.capacity >= 25
group by bu.building_id, bu.building_name
order by room_count desc, bu.building_name;


-- 3) Аудитории в которых есть проектор и как минимум 30 мест
select
    r.room_id,
    bu.building_name,
    r.room_number,
    r.capacity,
    r.type,
    re.quantity as projector_quantity
from campus.room r
join campus.building bu
    on r.building_id = bu.building_id
join campus.room_equipment re
    on r.room_id = re.room_id
join campus.equipment e
    on re.equipment_id = e.equipment_id
where e.equipment_name ilike '%проектор%'
  and r.capacity >= 30
order by r.capacity desc, bu.building_name, r.room_number;


-- 4) Топ пользователей по броням
select
    u.user_id,
    u.full_name,
    u.role,
    count(b.booking_id) as booking_count
from campus.users u
left join campus.booking b
    on u.user_id = b.user_id
group by u.user_id, u.full_name, u.role
order by booking_count desc, u.full_name;


-- 5) Количество бронирований по каждой из причине
select
    p.purpose_name,
    count(b.booking_id) as booking_count
from campus.purpose p
left join campus.booking b
    on p.purpose_id = b.purpose_id
group by p.purpose_id, p.purpose_name
order by booking_count desc, p.purpose_name;


-- 6) Все аудитории, которые не были ни разу забронированы
select
    r.room_id,
    bu.building_name,
    r.room_number,
    r.capacity,
    r.type
from campus.room r
join campus.building bu
  on r.building_id = bu.building_id
left join campus.booking b
  on r.room_id = b.room_id
where b.booking_id is null
order by bu.building_name, r.room_number;


-- 7) Средняя вместимость аудиторий
select
    r.type,
    count(*) as room_count,
    round(avg(r.capacity), 2) as avg_capacity,
    min(r.capacity) as min_capacity,
    max(r.capacity) as max_capacity
from campus.room r
group by r.type
order by avg_capacity desc;


-- 8) Корпуса, где больше всего мест
select
    bu.building_name,
    count(r.room_id) as room_count,
    sum(r.capacity) as total_capacity
from campus.building bu
left join campus.room r
    on bu.building_id = r.building_id
group by bu.building_id, bu.building_name
order by total_capacity desc, bu.building_name;

-- 9) 5 самых частых бронируемых аудиторий
select
    r.room_id,
    bu.building_name,
    r.room_number,
    count(b.booking_id) as booking_count
from campus.room r
join campus.building bu
    on r.building_id = bu.building_id
left join campus.booking b
    on r.room_id = b.room_id
group by r.room_id, bu.building_name, r.room_number
order by booking_count desc, bu.building_name, r.room_number
limit 5;

-- 10) Пользователи без активных броней
select
    u.user_id,
    u.full_name,
    u.role
from campus.users u
left join campus.booking b
    on u.user_id = b.user_id
   and b.status = 'active'
where b.booking_id is null
order by u.full_name;