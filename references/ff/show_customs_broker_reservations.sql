update shipping_schedules
set estimated_departure_date=DATE_ADD(
  estimated_departure_date,
  interval +1 year
);
