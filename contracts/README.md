# contracts

Three oracle smart contracts and an example consumer, written in CameLIGO. See the [main README](../README.md) for the comparison and the cost results.

| Folder | Contents |
|---|---|
| `oracle_bigmap/` | Readings in a `big_map` keyed by `(sensor_id, data_id)` |
| `oracle_map/` | Readings in a `map` keyed by `(sensor_id, data_id)` |
| `oracle_record_bigmap/` | Latest reading per sensor in a `big_map` keyed by `sensor_id` |
| `user/` | Example contract that reads an oracle through `Tezos.call_view` |

Each oracle folder has:

- `compile.sh`: compiles `contracts/main.mligo` and its initial storage to `main.tz` / `main_storage.tz` (gitignored)
- `run_tests.sh`: runs the unit tests in `contracts/test.mligo`
- `originate_sandbox.sh`: deploys to the local Flextesa sandbox (`../run_hangzbox.sh`)
- `originate.sh`: deploys to the Hangzhou testnet (retired; change the endpoint to a current testnet)

Before compiling, set the admin address in `contracts/init_main_storage.mligo`. Before originating, replace `<account_alias>` in the script with an account imported into `octez-client`.
