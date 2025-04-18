use std::str::FromStr;

use alloy::{
    hex,
    network::{EthereumWallet, TransactionBuilder},
    primitives::{address, Address, U256},
    providers::{Provider, ProviderBuilder},
    rpc::types::TransactionRequest,
    signers::local::PrivateKeySigner,
    sol,
};

sol!(
    #[sol(rpc)]
    SavingCircles,
    "../src/contracts/bytecode/SavingCircles.abi"
);

// expect("Well... you need the abi.\nGo make it.\nFirst flatten the contract\nforge flatten -o SavingCircles.flat.sol SavingCircles.sol\nThen get the abi from the flattened contract\nsolc SavingCircles.flat.sol --abi -o abi ");

#[tokio::main]
async fn main() -> eyre::Result<()> {
    // Spin up local Anvil node.
    let provider = ProviderBuilder::new().on_anvil_with_wallet();
    let addr = provider.get_accounts().await?;

    let bytecode = hex::decode(
        std::fs::read_to_string("../src/contracts/bytecode/SavingCircles.bin").expect(
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

    let ita = contract.isTokenAllowed(bread).send().await?.watch().await?;
    println!("yooooo:\n{ita}");
    let initialize = contract.initialize(addr[0]).send().await?.watch().await?;
    println!("{initialize}");
    let allowed = contract
        .setTokenAllowed(bread, true)
        .send()
        .await?
        .watch()
        .await?;
    println!("{allowed}");
    //let init = contract.initialize(addr[0]).send().await?.watch().await?;
    //println!("{:?}", init);
    let circle_id = contract.create(circle.into()).send().await?.watch().await?;

    println!("{circle_id:?}");

    Ok(())
}
