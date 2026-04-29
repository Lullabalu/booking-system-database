-- 1) Индекс по пользователям и сортировка по start_at
create index idx_booking_user_start
on campus.booking(user_id, start_at desc);

-- 2) Индекс по комнатам и сортировка по end_at
create index idx_booking_room_end
on campus.booking(room_id, end_at desc);

-- 3) Индекс по длине брони 
create index idx_booking_duration 
on campus.booking ((end_at - start_at));

-- 4) Индекс по цели бронирования
create index idx_booking_purpose_id
on campus.booking using hash (purpose_id);