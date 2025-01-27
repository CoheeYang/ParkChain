-include .env

deploy:; forge script script/Deployment.s.sol --rpc-url ${SEPOLIA_RPC_URL} --broadcast --private-key ${PRIVATE_KEY} --sender ${PUBLICTESTACCOUNT} --verify --etherscan-api-key ${ETHERSCAN_API_KEY} --optimize true  --optimizer-runs 100
IssuerOwner:; cast call --rpc-url ${SEPOLIA_RPC_URL} ${ISSUER_SEPOLIA} "owner()"
Issuer:; cast send --rpc-url ${SEPOLIA_RPC_URL} ${ISSUER_SEPOLIA} --private-key ${PRIVATE_KEY} "issue(address,string[],uint256,uint64,uint32,bytes32)" ${PUBLICTESTACCOUNT} ["1"] 1 ${SUBSCRIPTION_ID} 300000 ${DON_ID}
getAddress2Token:; cast call --rpc-url ${SEPOLIA_RPC_URL} ${PARKLOT_SEPOLIA} "getAddressToTokenIds(address)" ${PUBLICTESTACCOUNT}
getTokenId2URI:;  cast call --rpc-url ${SEPOLIA_RPC_URL} ${PARKLOT_SEPOLIA} "uri(uint256)" 0