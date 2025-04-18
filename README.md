flatten the contract
```
forge flatten src/contracts/SavingCircles.flat.sol -o src/contracts/SavingCircles.sol
```
make the abi and bytecode
```
solc src/contracts/SavingCircles.flat.sol --via-ir --optimize --bin --abi -o src/contracts/abi
```
