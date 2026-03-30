-- Все брони лекторов
SELECT
    b.booking_id,
    u.full_name AS lecture_name,
    bu.building_name,
    r.room_number,
    p.purpose_name,
    b.start_at,
    b.end_at,
    b.status
FROM campus.booking b
JOIN campus.users u
    ON b.user_id = u.user_id
JOIN campus.room r
    ON b.room_id = r.room_id
JOIN campus.building bu
    ON r.building_id = bu.building_id
JOIN campus.purpose p
    ON b.purpose_id = p.purpose_id
WHERE u.role = 'lecture'
  AND b.status = 'active'
ORDER BY b.start_at;


-- Количество семинарских аудиторий с вместимостью >= 25
SELECT
    bu.building_name,
    COUNT(r.room_id) AS room_count
FROM campus.building bu
LEFT JOIN campus.room r
    ON bu.building_id = r.building_id
WHERE r.type = 'seminar'
  AND r.capacity >= 25
GROUP BY bu.building_id, bu.building_name
ORDER BY room_count DESC, bu.building_name;


-- Аудитории в которых есть проектор и как минимум 30 мест
SELECT
    r.room_id,
    bu.building_name,
    r.room_number,
    r.capacity,
    r.type,
    re.quantity AS projector_quantity
FROM campus.room r
JOIN campus.building bu
    ON r.building_id = bu.building_id
JOIN campus.room_equipment re
    ON r.room_id = re.room_id
JOIN campus.equipment e
    ON re.equipment_id = e.equipment_id
WHERE e.equipment_name ILIKE '%проектор%'
  AND r.capacity >= 30
ORDER BY r.capacity DESC, bu.building_name, r.room_number;


-- Топ пользователей по броням
SELECT
    u.user_id,
    u.full_name,
    u.role,
    COUNT(b.booking_id) AS booking_count
FROM campus.users u
LEFT JOIN campus.booking b
    ON u.user_id = b.user_id
GROUP BY u.user_id, u.full_name, u.role
ORDER BY booking_count DESC, u.full_name;


-- Количество бронирований по каждой из причине
SELECT
    p.purpose_name,
    COUNT(b.booking_id) AS booking_count
FROM campus.purpose p
LEFT JOIN campus.booking b
    ON p.purpose_id = b.purpose_id
GROUP BY p.purpose_id, p.purpose_name
ORDER BY booking_count DESC, p.purpose_name;


-- Все аудитории, которые не были ни разу забронированы
SELECT
    r.room_id,
    bu.building_name,
    r.room_number,
    r.capacity,
    r.type
FROM campus.room r
JOIN campus.building bu
  ON r.building_id = bu.building_id
LEFT JOIN campus.booking b
  ON r.room_id = b.room_id
WHERE b.booking_id IS NULL
ORDER BY bu.building_name, r.room_number;


-- Средняя вместимость аудиторий
SELECT
    r.type,
    COUNT(*) AS room_count,
    ROUND(AVG(r.capacity), 2) AS avg_capacity,
    MIN(r.capacity) AS min_capacity,
    MAX(r.capacity) AS max_capacity
FROM campus.room r
GROUP BY r.type
ORDER BY avg_capacity DESC;


-- Корпуса, где больше всего мест
SELECT
    bu.building_name,
    COUNT(r.room_id) AS room_count,
    SUM(r.capacity) AS total_capacity
FROM campus.building bu
LEFT JOIN campus.room r
    ON bu.building_id = r.building_id
GROUP BY bu.building_id, bu.building_name
ORDER BY total_capacity DESC, bu.building_name;
