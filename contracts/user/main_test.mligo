#include "sc.mligo"

let test =
    let taccount : address = Test.nth_bootstrap_account (0) in
    let source = Test.set_source (taccount) in
    let initial_storage : storage =
        {
            oracleAddress = ("KT1CU9tjjT8KTxcAr5wKbNJYwZCVieejUcW4" : address);
            admin = taccount;
            price = 0n;
        } in
    let taddr, _, _ = Test.originate main initial_storage 0tez in

    let testOracle (p : action) (expected : {oracleAddress : address; admin : address; price : nat}) : unit = 
        let x = Test.to_contract taddr in
        let _ = Test.transfer_to_contract_exn x p 0tez in
        let s = Test.get_storage taddr in
        assert (s = expected)
    in

    let test1 = // oracle address is correct
        let p = UpdateOracle ("KT1CFk2cZZLZrLmrvDhdLgFznZVG7tkhRGNa" : address) in
        let () = Test.log (p) in
        testOracle (p) { oracleAddress = ("KT1CFk2cZZLZrLmrvDhdLgFznZVG7tkhRGNa" : address);
                         admin = taccount;
                         price = 0n;}                   
    in ()