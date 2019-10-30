pragma experimental ABIEncoderV2;
pragma solidity >=0.4.0 <0.7.0;

contract Wedding{
    enum ObjectionStatus {
            None,
            Pending,
            Completed,
            Rejected // We may need this someday!?
    }
    enum WeddingStatus {
        Pending,
        Completed,
        Terminated,
        PendingWithObjection
    }

    struct Guest{
        string name;
        string email;
        uint256 couponCode;
        uint256 ticket;
        bool decision;
        address etherumAddress;
    }

    function login(string memory guestname, int256  guestticket) view public returns (string memory);

    function acceptTheWedding(string memory name) public;

    function getWeddingInfo(string memory name) view public returns(string memory, string memory, //Name of the couple
                                                string memory, string memory, // Location
                                                string memory, string memory, // Date
                                                string memory, uint, // Num of paticipant
                                                string memory, string memory);

    function getGuestList() view public returns(Guest[] memory);

    function getGuestTicket(string memory name) view public returns (uint256);

    function opposeTheWedding(string memory reason, string memory name) public;

    function getObjectionStatus(string memory name) public view returns (string memory, string memory, uint256, uint256, uint8);

    function getCurrentVote(string memory name) view public returns(int8, uint256);

    function voteForObjection(string memory name, bool wannaStop) public; 

    function completeTheWedding() public;

    function terminateTheWedding() public;
}