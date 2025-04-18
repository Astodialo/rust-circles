/// flatten the contract at src/contracts with `forge flatten SavingCircles.sol -o SavingCircles.flat.sol
///
/// create the abi from the flat contract with `solc SavingCircles.flat.sol --via-ir --optimize --bin --abi -o abi`
use alloy::rpc::types::TransactionRequest;
use alloy::{
    hex,
    network::TransactionBuilder,
    primitives::{address, Address, U256},
    providers::{Provider, ProviderBuilder},
    sol,
};
use SavingCircles::CircleCreated;

sol!(
    #[sol(rpc)]
    SavingCircles,
    "../src/contracts/abi/SavingCircles.abi"
);

// expect("Well... you need the abi.\nGo make it.\nFirst flatten the contract\nforge flatten -o SavingCircles.flat.sol SavingCircles.sol\nThen get the abi from the flattened contract\nsolc SavingCircles.flat.sol --abi -o abi ");

#[tokio::main]
async fn main() -> eyre::Result<()> {
    // Spin up local Anvil node.
    let provider = ProviderBuilder::new().on_anvil_with_wallet();
    let addr = provider.get_accounts().await?;

    let bytecode = hex::decode(
        std::fs::read_to_string("../src/contracts/abi/SavingCircles.bin").expect(
            "Well... go make that bytecode.\nsolc SavingCircles.flat.sol --via-ir --optimize --bin -o bytecode\n",
        ),
    )?;
    let tx = TransactionRequest::default().with_deploy_code(bytecode);

    let receipt = provider.send_transaction(tx).await?.get_receipt().await?;
    let contract_adr = receipt
        .contract_address
        .expect("Failed to get contract address ig");

    let contract = SavingCircles::new(contract_adr, provider.clone());

    println!("Deployed contract at address: {}", contract_adr);
    std::fs::write("./addr", contract.address().to_string())
        .expect("Should have written the contract address");

    let bread: Address = address!("0xa555d5344f6FB6c65da19e403Cb4c1eC4a1a5Ee3");

    let circle: ISavingCircles::Circle = ISavingCircles::Circle {
        owner: addr[0],
        members: vec![addr[1], addr[2], addr[3]],
        currentIndex: U256::from(0),
        depositAmount: U256::from(10000),
        token: bread,
        depositInterval: U256::from(100),
        circleStart: U256::from(1000),
        maxDeposits: U256::from(1000000),
    };

    let initialize = contract.initialize(addr[0]).send().await?.watch().await?;
    println!("> initialiazed with address: {}\n> txhash: {initialize}", {
        addr[0]
    });
    let allowed = contract
        .setTokenAllowed(bread, true)
        .send()
        .await?
        .watch()
        .await?;
    println!("> token allowed: {}\n> txhash: {allowed}", { bread });
    let circle_tx = contract.create(circle).send().await?;
    let receipt = circle_tx.get_receipt().await?;
    let tx_hash = receipt.transaction_hash;
    println!("> circle created!\n> txhash {tx_hash:?}");
    let created_crcl = receipt.clone().inner.logs()[0]
        .log_decode::<CircleCreated>()
        .expect("well... that sucks :()");
    let circle_id = created_crcl.inner.id;
    println!("> circle id: {:?}", circle_id);

    let circle2: ISavingCircles::Circle = ISavingCircles::Circle {
        owner: addr[0],
        members: vec![addr[1], addr[2], addr[4]],
        currentIndex: U256::from(0),
        depositAmount: U256::from(10000),
        token: bread,
        depositInterval: U256::from(100),
        circleStart: U256::from(1000),
        maxDeposits: U256::from(1000000),
    };

    let circle2_tx = contract.create(circle2).send().await?;
    let receipt2 = circle2_tx.get_receipt().await?;
    let tx2_hash = receipt2.transaction_hash;
    println!("> circle created!\n> txhash {tx2_hash:?}");
    let created_crcl2 = receipt2.clone().inner.logs()[0]
        .log_decode::<CircleCreated>()
        .expect("well... that sucks :()");
    let circle2_id = created_crcl2.inner.id;
    println!("> circle id: {:?}", circle2_id);

    Ok(())
}
