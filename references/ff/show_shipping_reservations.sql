update shipping_status_translations
set name='Confirmed BL Draft'
where shipping_status_id=20;

update shipping_status_translations
set name='Original Bill of Lading Released'
where shipping_status_id=33;

update shipping_reservations
set domestic_reservation_event_status_id=33
where id in (1, 2, 3, 7, 8, 9);

update shipping_reservations
set export_reservation_event_status_id=20
where id in (12, 11, 10, 6, 4);

select @agent_id := agents.id, @company_id := agents.port_operator_company_id
from users as U
inner join cms_profiles as cms on U.id = cms.user_id
inner join port_operator_agents as agents on cms.port_operator_agent_id=agents.id
where username in ('port_user', 'portuser');

-- Assign ports to the company

select @origin_export := id
from transit_points
where name='Origin (Export)';

select @destination_domestic := id
from transit_points
where name='Destination (Domestic)';

insert into port_operator_company_transit_point(
  port_operator_company_id,
  transit_point_id
) values (@company_id, @origin_export);

insert into port_operator_company_transit_point(
  port_operator_company_id,
  transit_point_id
) values (@company_id, @destination_domestic);

-- Assign ports to the agent

insert into port_operator_agent_transit_point(
  port_operator_agent_id,
  transit_point_id
) values (@agent_id, @origin_export);

insert into port_operator_agent_transit_point(
  port_operator_agent_id,
  transit_point_id
) values (@agent_id, @destination_domestic);

/*
FYR FE/BE to have export/import shipping reservations in local

Update port agents port. Must have
Origin (Export)
Destination (Domestic)

Update the shipping_status_translation WHERE shipping_status_id IN (20, 33)
name => Confirmed BL Draft - for 20
name => Original Bill of Lading Released - for 33

Update the shipping reservations where id IN (1, 2, 3, 7, 8, 9) - sample data

domestic_reservation_event_status_id => 33

Update the shipping reservations where id IN (12, 11, 10, 6, 4) - sample data
export_reservation_event_status_id => 20

Please take note of this. Thanks
*/
