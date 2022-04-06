type sensor_id 	= nat

type add_param = 
{
   sensor_id : sensor_id;
   data      : nat; 
}

type get_param =
{
    sensor_id : sensor_id;
}

type withdraw_param =
{
    tez_amt : tez;
}

// parameter type
type parameter =
    | Add_data of add_param
    | Add_sensor of sensor_id
	| Remove_sensor of sensor_id
    | Update_admin of address
    | Withdraw of withdraw_param

// storage type
type sensor_ledger = (sensor_id, nat) big_map

type storage = 
{ 
    sensor_ledger : sensor_ledger;
    admin         : address 
}

type return = (operation list) * storage
