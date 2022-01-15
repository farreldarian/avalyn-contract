// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

error CannotReceiveEther();

contract AvalynCompounder is Ownable {
    struct Pool {
        address addr;
    }

    struct PoolWithId {
        bytes32 id;
        address addr;
    }

    mapping(bytes32 => Pool) public pools;

    constructor(PoolWithId[] memory _pools) {
        initializePools(_pools);
    }

    function initializePools(PoolWithId[] memory _pools) private {
        uint256 len = _pools.length;
        for (uint256 i = 0; i < len; i++) {
            PoolWithId memory pool = _pools[i];
            pools[pool.id] = Pool({addr: pool.addr});
        }
    }

    function withdrawToken(IERC20 token, uint256 amount) external onlyOwner {
        token.transfer(msg.sender, amount);
    }

    receive() external payable {
        if (msg.value > 0) revert CannotReceiveEther();
    }
}
