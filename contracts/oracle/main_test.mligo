#include "oracle.mligo"

let test =
    let initial_storage = 0n in
    let taddr, _, _ = Test.originate main initial_storage 0tez in
    let contract = Test.to_contract(taddr) in
    let _r = Test.transfer_to_contract_exn contract (Update (3n)) 1tez in
    assert (Test.get_storage(taddr) <> initial_storage + 4n)