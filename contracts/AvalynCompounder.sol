// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfaces/IUniswapV2Router02.sol";

error CannotReceiveEther();

contract AvalynCompounder is Ownable {
    struct Pool {
        address factory;
        address tokenA;
        address tokenB;
    }

    struct PoolWithAddress {
        address addr;
        address factory;
        address tokenA;
        address tokenB;
    }

    mapping(address => Pool) public pools;

    constructor(PoolWithAddress[] memory _pools) {
        initializePools(_pools);
    }

    function initializePools(PoolWithAddress[] memory _pools) private {
        uint256 len = _pools.length;
        for (uint256 i = 0; i < len; i++) {
            PoolWithAddress memory pool = _pools[i];
            pools[pool.addr] = Pool({
                factory: pool.factory,
                tokenA: pool.tokenA,
                tokenB: pool.tokenB
            });
        }
    }

    function addLiquidity(
        address payable _pool,
        bool _isOneForTwo,
        uint256 _amountA,
        uint256 _amountB,
        uint256 _amountAMin,
        uint256 _amountBMin,
        address[] memory _path,
        uint256 _deadline
    ) public {
        if (_isOneForTwo) {
            IUniswapV2Router02(_pool).swapExactTokensForTokens(
                _amountA,
                _amountBMin,
                _path,
                msg.sender,
                _deadline
            );
        } else {
            IUniswapV2Router02(_pool).swapExactTokensForTokens(
                _amountB,
                _amountAMin,
                _path,
                msg.sender,
                _deadline
            );
        }

        IUniswapV2Router02(_pool).addLiquidity(
            pools[_pool].tokenA,
            pools[_pool].tokenB,
            _amountA,
            _amountB,
            _amountAMin,
            _amountBMin,
            msg.sender,
            _deadline
        );
    }

    function withdrawToken(IERC20 token, uint256 amount) external onlyOwner {
        token.transfer(msg.sender, amount);
    }

    receive() external payable {
        if (msg.value > 0) revert CannotReceiveEther();
    }
}
