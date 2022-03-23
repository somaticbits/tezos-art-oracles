type view_param =
{
    sensor_id : nat;
    data_id   : nat;
}

type get_param =
{
    parameter : view_param;
    addr      : address;
}

// parameter type
type parameter = 
    | Get_data of get_param
    | Update_oracle of address

// storage type
type storage = 
{
    oracle_address : address;
    admin          : address;
    data           : nat option;
}

type return = (operation list) * storage
