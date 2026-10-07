# contracts

Three oracle smart contracts and an example consumer, written in CameLIGO. See the [main README](../README.md) for the comparison and the cost results.

| Folder | Contents |
|---|---|
| `oracle_bigmap/` | Readings in a `big_map` keyed by `(sensor_id, data_id)` |
| `oracle_map/` | Readings in a `map` keyed by `(sensor_id, data_id)` |
| `oracle_record_bigmap/` | Latest reading per sensor in a `big_map` keyed by `sensor_id` |
| `user/` | Example contract that reads an oracle through `Tezos.call_view` |

The compiled Michelson (`<prototype>/contracts/main.tz` and `main_storage.tz`) is committed, so the [benchmark](../benchmark) runs without LIGO. Their initial storage registers sensor `0` with the Flextesa sandbox's `alice` account as admin.

To recompile and run the LIGO tests, with LIGO pinned to 0.38.1 in Docker:

```bash
./compile_all.sh
```

0.38.1 is pinned on purpose: 0.40 and later reject the tests (the Test API changed), and 0.43 and later reject `oracle_record_bigmap`, which calls `Map.add` / `Map.remove` on a `big_map`. CI recompiles and fails if the committed Michelson differs from the sources.

`run_sandbox.sh` starts a local Flextesa sandbox (Oxford protocol, the newest in the last published Flextesa image) on port 20000.

Each oracle folder also has the original per-contract scripts, which expect a local `ligo` and `octez-client` (formerly `tezos-client`):

- `compile.sh`: compiles `contracts/main.mligo` and its initial storage to `main.tz` / `main_storage.tz`
- `run_tests.sh`: runs the unit tests in `contracts/test.mligo`
- `originate_sandbox.sh`: deploys to the local sandbox
- `originate.sh`: deploys to the Hangzhou testnet (retired; change the endpoint to a current testnet)

`originate.sh` sends from an `octez-client` account aliased `ligoacct`; import one under that name or edit the script.
