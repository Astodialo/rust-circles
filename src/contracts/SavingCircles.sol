// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20 ^0.8.28;

// src/contracts/SavingCircles.flat.sol

// src/contracts/SavingCircles.sol

// src/contracts/SavingCircles.flat.sol

// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol

// OpenZeppelin Contracts (last updated v5.1.0) (token/ERC20/IERC20.sol)

/**
 * @dev Interface of the ERC-20 standard as defined in the ERC.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the value of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the value of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 value) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

// lib/openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol

// OpenZeppelin Contracts (last updated v5.1.0) (utils/ReentrancyGuard.sol)

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If EIP-1153 (transient storage) is available on the chain you're deploying at,
 * consider using {ReentrancyGuardTransient} instead.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant NOT_ENTERED = 1;
    uint256 private constant ENTERED = 2;

    uint256 private _status;

    /**
     * @dev Unauthorized reentrant call.
     */
    error ReentrancyGuardReentrantCall();

    constructor() {
        _status = NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be NOT_ENTERED
        if (_status == ENTERED) {
            revert ReentrancyGuardReentrantCall();
        }

        // Any calls to nonReentrant after this point will fail
        _status = ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = NOT_ENTERED;
    }

    /**
     * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
     * `nonReentrant` function in the call stack.
     */
    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == ENTERED;
    }
}

// lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol

// OpenZeppelin Contracts (last updated v5.3.0) (proxy/utils/Initializable.sol)

/**
 * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
 * behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
 * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
 * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
 *
 * The initialization functions use a version number. Once a version number is used, it is consumed and cannot be
 * reused. This mechanism prevents re-execution of each "step" but allows the creation of new initialization steps in
 * case an upgrade adds a module that needs to be initialized.
 *
 * For example:
 *
 * [.hljs-theme-light.nopadding]
 * ```solidity
 * contract MyToken is ERC20Upgradeable {
 *     function initialize() initializer public {
 *         __ERC20_init("MyToken", "MTK");
 *     }
 * }
 *
 * contract MyTokenV2 is MyToken, ERC20PermitUpgradeable {
 *     function initializeV2() reinitializer(2) public {
 *         __ERC20Permit_init("MyToken");
 *     }
 * }
 * ```
 *
 * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
 * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
 *
 * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
 * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
 *
 * [CAUTION]
 * ====
 * Avoid leaving a contract uninitialized.
 *
 * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
 * contract, which may impact the proxy. To prevent the implementation contract from being used, you should invoke
 * the {_disableInitializers} function in the constructor to automatically lock it when it is deployed:
 *
 * [.hljs-theme-light.nopadding]
 * ```
 * /// @custom:oz-upgrades-unsafe-allow constructor
 * constructor() {
 *     _disableInitializers();
 * }
 * ```
 * ====
 */
abstract contract Initializable {
    /**
     * @dev Storage of the initializable contract.
     *
     * It's implemented on a custom ERC-7201 namespace to reduce the risk of storage collisions
     * when using with upgradeable contracts.
     *
     * @custom:storage-location erc7201:openzeppelin.storage.Initializable
     */
    struct InitializableStorage {
        /**
         * @dev Indicates that the contract has been initialized.
         */
        uint64 _initialized;
        /**
         * @dev Indicates that the contract is in the process of being initialized.
         */
        bool _initializing;
    }

    // keccak256(abi.encode(uint256(keccak256("openzeppelin.storage.Initializable")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant INITIALIZABLE_STORAGE = 0xf0c57e16840df040f15088dc2f81fe391c3923bec73e23a9662efc9c229c6a00;

    /**
     * @dev The contract is already initialized.
     */
    error InvalidInitialization();

    /**
     * @dev The contract is not initializing.
     */
    error NotInitializing();

    /**
     * @dev Triggered when the contract has been initialized or reinitialized.
     */
    event Initialized(uint64 version);

    /**
     * @dev A modifier that defines a protected initializer function that can be invoked at most once. In its scope,
     * `onlyInitializing` functions can be used to initialize parent contracts.
     *
     * Similar to `reinitializer(1)`, except that in the context of a constructor an `initializer` may be invoked any
     * number of times. This behavior in the constructor can be useful during testing and is not expected to be used in
     * production.
     *
     * Emits an {Initialized} event.
     */
    modifier initializer() {
        // solhint-disable-next-line var-name-mixedcase
        InitializableStorage storage $ = _getInitializableStorage();

        // Cache values to avoid duplicated sloads
        bool isTopLevelCall = !$._initializing;
        uint64 initialized = $._initialized;

        // Allowed calls:
        // - initialSetup: the contract is not in the initializing state and no previous version was
        //                 initialized
        // - construction: the contract is initialized at version 1 (no reinitialization) and the
        //                 current contract is just being deployed
        bool initialSetup = initialized == 0 && isTopLevelCall;
        bool construction = initialized == 1 && address(this).code.length == 0;

        if (!initialSetup && !construction) {
            revert InvalidInitialization();
        }
        $._initialized = 1;
        if (isTopLevelCall) {
            $._initializing = true;
        }
        _;
        if (isTopLevelCall) {
            $._initializing = false;
            emit Initialized(1);
        }
    }

    /**
     * @dev A modifier that defines a protected reinitializer function that can be invoked at most once, and only if the
     * contract hasn't been initialized to a greater version before. In its scope, `onlyInitializing` functions can be
     * used to initialize parent contracts.
     *
     * A reinitializer may be used after the original initialization step. This is essential to configure modules that
     * are added through upgrades and that require initialization.
     *
     * When `version` is 1, this modifier is similar to `initializer`, except that functions marked with `reinitializer`
     * cannot be nested. If one is invoked in the context of another, execution will revert.
     *
     * Note that versions can jump in increments greater than 1; this implies that if multiple reinitializers coexist in
     * a contract, executing them in the right order is up to the developer or operator.
     *
     * WARNING: Setting the version to 2**64 - 1 will prevent any future reinitialization.
     *
     * Emits an {Initialized} event.
     */
    modifier reinitializer(uint64 version) {
        // solhint-disable-next-line var-name-mixedcase
        InitializableStorage storage $ = _getInitializableStorage();

        if ($._initializing || $._initialized >= version) {
            revert InvalidInitialization();
        }
        $._initialized = version;
        $._initializing = true;
        _;
        $._initializing = false;
        emit Initialized(version);
    }

    /**
     * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
     * {initializer} and {reinitializer} modifiers, directly or indirectly.
     */
    modifier onlyInitializing() {
        _checkInitializing();
        _;
    }

    /**
     * @dev Reverts if the contract is not in an initializing state. See {onlyInitializing}.
     */
    function _checkInitializing() internal view virtual {
        if (!_isInitializing()) {
            revert NotInitializing();
        }
    }

    /**
     * @dev Locks the contract, preventing any future reinitialization. This cannot be part of an initializer call.
     * Calling this in the constructor of a contract will prevent that contract from being initialized or reinitialized
     * to any version. It is recommended to use this to lock implementation contracts that are designed to be called
     * through proxies.
     *
     * Emits an {Initialized} event the first time it is successfully executed.
     */
    function _disableInitializers() internal virtual {
        // solhint-disable-next-line var-name-mixedcase
        InitializableStorage storage $ = _getInitializableStorage();

        if ($._initializing) {
            revert InvalidInitialization();
        }
        if ($._initialized != type(uint64).max) {
            $._initialized = type(uint64).max;
            emit Initialized(type(uint64).max);
        }
    }

    /**
     * @dev Returns the highest version that has been initialized. See {reinitializer}.
     */
    function _getInitializedVersion() internal view returns (uint64) {
        return _getInitializableStorage()._initialized;
    }

    /**
     * @dev Returns `true` if the contract is currently initializing. See {onlyInitializing}.
     */
    function _isInitializing() internal view returns (bool) {
        return _getInitializableStorage()._initializing;
    }

    /**
     * @dev Pointer to storage slot. Allows integrators to override it with a custom storage location.
     *
     * NOTE: Consider following the ERC-7201 formula to derive storage locations.
     */
    function _initializableStorageSlot() internal pure virtual returns (bytes32) {
        return INITIALIZABLE_STORAGE;
    }

    /**
     * @dev Returns a pointer to the storage namespace.
     */
    // solhint-disable-next-line var-name-mixedcase
    function _getInitializableStorage() private pure returns (InitializableStorage storage $) {
        bytes32 slot = _initializableStorageSlot();
        assembly {
            $.slot := slot
        }
    }
}

// src/interfaces/ISavingCircles.sol

interface ISavingCircles {
  /*///////////////////////////////////////////////////////////////
                            STRUCTS
  //////////////////////////////////////////////////////////////*/

  struct Circle {
    address owner;
    address[] members;
    uint256 currentIndex;
    uint256 depositAmount;
    address token;
    uint256 depositInterval;
    uint256 circleStart;
    uint256 maxDeposits;
  }

  /*///////////////////////////////////////////////////////////////
                            EVENTS
  //////////////////////////////////////////////////////////////*/

  event CircleCreated(
    uint256 indexed id, address[] members, address token, uint256 depositAmount, uint256 depositInterval
  );
  event CircleDecommissioned(uint256 indexed id);
  event FundsDeposited(uint256 indexed id, address indexed member, uint256 amount);
  event FundsWithdrawn(uint256 indexed id, address indexed member, uint256 amount);
  event TokenAllowed(address indexed token, bool indexed allowed);

  /*///////////////////////////////////////////////////////////////
                            ERRORS
  //////////////////////////////////////////////////////////////*/

  error AlreadyDeposited();
  error AlreadyExists();
  error InvalidDeposit();
  error InvalidCircle();
  error NotCommissioned();
  error NotMember();
  error NotDecommissionable();
  error NotWithdrawable();
  error TransferFailed();
  error DepositWindowClosed();
  error CircleExpired();
  error ExceedsDepositAmount();
  error DepositBeforeCircleStart();
  error TokenNotAllowed();
  error InvalidDepositInterval();
  error InvalidDepositAmount();
  error InvalidMaxDeposits();
  error InvalidCircleStartTime();
  error InvalidCurrentIndex();
  error InvalidOwner();
  error InvalidMemberCount();
  error InvalidMemberAddress();

  /*///////////////////////////////////////////////////////////////
                            VIEW
  //////////////////////////////////////////////////////////////*/

  function initialize(address owner) external;
  function setTokenAllowed(address token, bool allowed) external;
  function create(Circle memory circle) external returns (uint256);
  function deposit(uint256 id, uint256 value) external;
  function depositFor(uint256 id, uint256 value, address member) external;
  function withdraw(uint256 id) external;
  function withdrawFor(uint256 id, address member) external;
  function decommission(uint256 id) external;

  /*///////////////////////////////////////////////////////////////
                            VIEW
  //////////////////////////////////////////////////////////////*/

  function getCircle(uint256 id) external view returns (Circle memory);
  function getCircles(uint256[] calldata ids) external view returns (Circle[] memory);
  function getMemberCircles(address member) external view returns (uint256[] memory);
  function getMemberBalances(uint256 id) external view returns (address[] memory, uint256[] memory);
  function checkMemberships(address member, uint256[] calldata ids) external view returns (bool[] memory);
  function isTokenAllowed(address token) external view returns (bool);
  function isWithdrawable(uint256 id) external view returns (bool);
  function withdrawableBy(uint256 id) external view returns (address);
}

// lib/openzeppelin-contracts-upgradeable/contracts/utils/ContextUpgradeable.sol

// OpenZeppelin Contracts (last updated v5.0.1) (utils/Context.sol)

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract ContextUpgradeable is Initializable {
    function __Context_init() internal onlyInitializing {
    }

    function __Context_init_unchained() internal onlyInitializing {
    }
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    function _contextSuffixLength() internal view virtual returns (uint256) {
        return 0;
    }
}

// lib/openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol

// OpenZeppelin Contracts (last updated v5.0.0) (access/Ownable.sol)

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * The initial owner is set to the address provided by the deployer. This can
 * later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
    /// @custom:storage-location erc7201:openzeppelin.storage.Ownable
    struct OwnableStorage {
        address _owner;
    }

    // keccak256(abi.encode(uint256(keccak256("openzeppelin.storage.Ownable")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant OwnableStorageLocation = 0x9016d09d72d40fdae2fd8ceac6b6234c7706214fd39c1cd1e609a0528c199300;

    function _getOwnableStorage() private pure returns (OwnableStorage storage $) {
        assembly {
            $.slot := OwnableStorageLocation
        }
    }

    /**
     * @dev The caller account is not authorized to perform an operation.
     */
    error OwnableUnauthorizedAccount(address account);

    /**
     * @dev The owner is not a valid owner account. (eg. `address(0)`)
     */
    error OwnableInvalidOwner(address owner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the address provided by the deployer as the initial owner.
     */
    function __Ownable_init(address initialOwner) internal onlyInitializing {
        __Ownable_init_unchained(initialOwner);
    }

    function __Ownable_init_unchained(address initialOwner) internal onlyInitializing {
        if (initialOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(initialOwner);
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        OwnableStorage storage $ = _getOwnableStorage();
        return $._owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        if (owner() != _msgSender()) {
            revert OwnableUnauthorizedAccount(_msgSender());
        }
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        OwnableStorage storage $ = _getOwnableStorage();
        address oldOwner = $._owner;
        $._owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// src/contracts/SavingCircles.sol

/**
 * @title Saving Circles
 * @notice Simple implementation of a rotating savings and credit association (ROSCA) for ERC20 tokens
 * @author Breadchain Collective
 * @author @RonTuretzky
 * @author bagelface.eth
 */
contract SavingCircles is ISavingCircles, ReentrancyGuard, OwnableUpgradeable {
  uint256 public constant MINIMUM_MEMBERS = 2;

  uint256 public nextId;
  mapping(uint256 id => Circle circle) public circles;
  mapping(uint256 id => mapping(address token => uint256 balance)) public balances;
  mapping(uint256 id => mapping(address member => bool status)) public isMember;
  mapping(address member => uint256[] ids) public memberCircles;
  mapping(address token => bool status) public allowedTokens;

  /// @custom:oz-upgrades-unsafe-allow constructor
  // constructor() {
  //   _disableInitializers();
  // }

  function initialize(address _owner) external override initializer {
    __Ownable_init_unchained(_owner);
  }

  /**
   * @notice Create a new saving circle
   * @param _circle A new saving circle
   */
  function create(Circle memory _circle) external override returns (uint256 _id) {
    _id = nextId++;

    if (circles[_id].owner != address(0)) revert AlreadyExists();
    if (!allowedTokens[_circle.token]) revert TokenNotAllowed();
    if (_circle.depositInterval == 0) revert InvalidDepositInterval();
    if (_circle.depositAmount == 0) revert InvalidDepositAmount();
    if (_circle.maxDeposits == 0) revert InvalidMaxDeposits();
    if (_circle.circleStart == 0) revert InvalidCircleStartTime();
    if (_circle.currentIndex != 0) revert InvalidCurrentIndex();
    if (_circle.owner == address(0)) revert InvalidOwner();
    if (_circle.members.length < MINIMUM_MEMBERS) revert InvalidMemberCount();

    for (uint256 i = 0; i < _circle.members.length; i++) {
      address _member = _circle.members[i];
      if (_member == address(0)) revert InvalidMemberAddress();
      isMember[_id][_member] = true;
      memberCircles[_member].push(_id);
    }

    circles[_id] = _circle;

    emit CircleCreated(_id, _circle.members, _circle.token, _circle.depositAmount, _circle.depositInterval);

    return _id;
  }

  /**
   * @notice Make a deposit into a specified circle
   * @param _id Identifier of the circle
   * @param _value Amount of the token to deposit
   */
  function deposit(uint256 _id, uint256 _value) external override nonReentrant {
    _deposit(_id, _value, msg.sender);
  }

  /**
   * @notice Make a deposit on behalf of another member
   * @param _id Identifier of the circle
   * @param _value Amount of the token to deposit
   * @param _member Address to make a deposit for
   */
  function depositFor(uint256 _id, uint256 _value, address _member) external override nonReentrant {
    _deposit(_id, _value, _member);
  }

  /**
   * @notice Make a withdrawal from a specified circle
   * @param _id Identifier of the circle
   */
  function withdraw(uint256 _id) external override nonReentrant {
    _withdraw(_id, msg.sender);
  }

  /**
   * @notice Make a withdrawal from a specified circle on behalf of another member
   * @param _id Identifier of the circle
   * @param _member Address of the member to make a withdrawal for
   */
  function withdrawFor(uint256 _id, address _member) external override nonReentrant {
    _withdraw(_id, _member);
  }

  /**
   * @notice Set if a token can be used for saving circles
   * @param _token Token to update the status of
   * @param _allowed Can be used for saving circles
   */
  function setTokenAllowed(address _token, bool _allowed) external override onlyOwner {
    allowedTokens[_token] = _allowed;

    emit TokenAllowed(_token, _allowed);
  }

  /**
   * @notice Decommission an existing saving circle
   * @dev Returns all deposits to members
   * @param _id Identifier of the circle
   */
  function decommission(uint256 _id) external override {
    Circle storage _circle = circles[_id];

    if (_circle.owner != msg.sender) {
      if (!isMember[_id][msg.sender]) revert NotMember();
      if (block.timestamp <= _circle.circleStart + (_circle.depositInterval * (_circle.currentIndex + 1))) {
        revert NotDecommissionable();
      }

      bool hasIncompleteDeposits = false;
      for (uint256 i = 0; i < _circle.members.length; i++) {
        if (balances[_id][_circle.members[i]] < _circle.depositAmount) {
          hasIncompleteDeposits = true;
          break;
        }
      }
      if (!hasIncompleteDeposits) revert NotDecommissionable();
    }

    // Return deposits to members
    for (uint256 i = 0; i < _circle.members.length; i++) {
      address _member = _circle.members[i];
      uint256 _balance = balances[_id][_member];

      if (_balance > 0) {
        balances[_id][_member] = 0;
        bool success = IERC20(_circle.token).transfer(_member, _balance);
        if (!success) revert TransferFailed();
      }
    }

    delete circles[_id];

    emit CircleDecommissioned(_id);
  }

  /**
   * @notice Return if a token is allowed to be used for saving circles
   * @param _token Address of a token
   * @return bool Token allowed
   */
  function isTokenAllowed(address _token) external view override returns (bool) {
    return allowedTokens[_token];
  }

  /**
   * @notice Return the info of a specified saving circle
   * @param _id Identifier of the circle
   * @return _circle Saving circle
   */
  function getCircle(uint256 _id) external view override returns (Circle memory _circle) {
    _circle = circles[_id];

    if (_isDecommissioned(_circle)) revert NotCommissioned();

    return _circle;
  }

  /**
   * @notice Get multiple circles in a single call
   * @param _ids Array of circle IDs to fetch
   * @return _circles Array of circles
   */
  function getCircles(uint256[] calldata _ids) external view returns (Circle[] memory _circles) {
    _circles = new Circle[](_ids.length);

    for (uint256 i = 0; i < _ids.length; i++) {
      _circles[i] = circles[_ids[i]];
    }

    return _circles;
  }

  /**
   * @notice Get all circles for a specific member
   * @param _member Address of the member
   * @return _ids Array of circle IDs the member belongs to
   */
  function getMemberCircles(address _member) external view returns (uint256[] memory _ids) {
    return memberCircles[_member];
  }

  /**
   * @notice Return the balances of the members of a specified saving circle
   * @param _id Identifier of the circle
   * @return _members Members of the specified saving circle
   * @return _balances Corresponding balances of the members of the circle
   */
  function getMemberBalances(uint256 _id)
    external
    view
    override
    returns (address[] memory _members, uint256[] memory _balances)
  {
    Circle memory _circle = circles[_id];

    if (_isDecommissioned(_circle)) revert NotCommissioned();

    _balances = new uint256[](_circle.members.length);
    for (uint256 i = 0; i < _circle.members.length; i++) {
      _balances[i] = balances[_id][_circle.members[i]];
    }

    return (_circle.members, _balances);
  }

  /**
   * @notice Check membership status for multiple circles
   * @param _member Address to check
   * @param _ids Array of circle IDs to check
   * @return _statuses Array of boolean membership statuses
   */
  function checkMemberships(address _member, uint256[] calldata _ids) external view returns (bool[] memory _statuses) {
    _statuses = new bool[](_ids.length);

    for (uint256 i = 0; i < _ids.length; i++) {
      _statuses[i] = isMember[_ids[i]][_member];
    }

    return _statuses;
  }

  /**
   * @notice Return the member address which is currently able to withdraw from a specified circle
   * @param _id Identifier of the circle
   * @return address Member that is currently able to withdraw from the circle
   */
  function withdrawableBy(uint256 _id) external view override returns (address) {
    Circle memory _circle = circles[_id];

    if (_isDecommissioned(_circle)) revert NotCommissioned();

    return _circle.members[_circle.currentIndex];
  }

  /**
   * @notice Return if a circle can currently be withdrawn from
   * @param _id Identifier of the circle
   * @return bool If the circle is able to be withdrawn from
   */
  function isWithdrawable(uint256 _id) external view override returns (bool) {
    return _withdrawable(_id);
  }

  /**
   * @dev Make a withdrawal from a specified circle
   *      A withdrawal must be made by a member of the circle, even if it is for another member.
   */
  function _withdraw(uint256 _id, address _member) internal {
    Circle storage _circle = circles[_id];

    if (!isMember[_id][msg.sender]) revert NotMember();
    if (!_withdrawable(_id)) revert NotWithdrawable();
    if (_circle.members[_circle.currentIndex] != _member) revert NotWithdrawable();
    if (_circle.currentIndex >= _circle.maxDeposits) revert NotWithdrawable();

    uint256 _withdrawAmount = _circle.depositAmount * (_circle.members.length);

    for (uint256 i = 0; i < _circle.members.length; i++) {
      balances[_id][_circle.members[i]] = 0;
    }

    _circle.currentIndex = (_circle.currentIndex + 1) % _circle.members.length;
    bool success = IERC20(_circle.token).transfer(_member, _withdrawAmount);
    if (!success) revert TransferFailed();

    emit FundsWithdrawn(_id, _member, _withdrawAmount);
  }

  /**
   * @dev Make a deposit into a specified circle
   *      A deposit must be made in specific time window and can be made partially so long as the final balance equals
   *      the specified deposit amount for the circle.
   */
  function _deposit(uint256 _id, uint256 _value, address _member) internal {
    Circle memory _circle = circles[_id];

    if (_isDecommissioned(_circle)) revert NotCommissioned();
    if (!isMember[_id][_member]) revert NotMember();
    if (block.timestamp < circles[_id].circleStart) {
      revert DepositBeforeCircleStart();
    }
    if (block.timestamp >= circles[_id].circleStart + (circles[_id].depositInterval * (circles[_id].currentIndex + 1)))
    {
      revert DepositWindowClosed();
    }
    if (block.timestamp >= circles[_id].circleStart + (circles[_id].depositInterval * circles[_id].maxDeposits)) {
      revert CircleExpired();
    }
    if (balances[_id][_member] + _value > circles[_id].depositAmount) {
      revert ExceedsDepositAmount();
    }

    balances[_id][_member] = balances[_id][_member] + _value;

    bool success = IERC20(_circle.token).transferFrom(msg.sender, address(this), _value);
    if (!success) revert TransferFailed();

    emit FundsDeposited(_id, _member, _value);
  }

  /**
   * @dev Return if a specified circle is withdrawable
   *      To be considered withdrawable, enough time must have passed since the deposit interval started
   *      and all members must have made a deposit.
   */
  function _withdrawable(uint256 _id) internal view returns (bool) {
    Circle memory _circle = circles[_id];

    if (_isDecommissioned(_circle)) revert NotCommissioned();

    if (block.timestamp < _circle.circleStart + (_circle.depositInterval * _circle.currentIndex)) {
      return false;
    }

    for (uint256 i = 0; i < _circle.members.length; i++) {
      if (balances[_id][_circle.members[i]] < _circle.depositAmount) {
        return false;
      }
    }

    return true;
  }

  /**
   * @dev Return if a specified circle is decommissioned by checking if an owner is set
   */
  function _isDecommissioned(Circle memory _circle) internal pure returns (bool) {
    return _circle.owner == address(0);
  }
}
