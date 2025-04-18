flatten the contract
```
forge flatten src/contracts/SavingCircles.sol -o src/contracts/SavingCircles.flat.sol
```
make the abi and bytecode
```
solc src/contracts/SavingCircles.flat.sol --via-ir --optimize --bin --abi -o src/contracts/abi
```
go to the app folder and do `cargo run` 
