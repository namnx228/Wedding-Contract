pragma experimental ABIEncoderV2;
pragma solidity >=0.4.0 <0.7.0;

contract Wedding{
    function login(string memory guestname, int256  guestticket) view public returns (string memory);

    function acceptTheWedding(string memory name) public;

    function getWeddingInfo(string memory name) view public returns(string memory, string memory, //Name of the couple
                                                string memory, string memory, // Location
                                                string memory, string memory, // Date
                                                string memory, uint, // Num of paticipant
                                                string memory, string memory);

    function getGuestTicket(string memory name) view public returns (uint256);

    function opposeTheWedding(string memory reason, string memory name) public;

    function getObjectionStatus(string memory name) public view returns (string memory, string memory, uint256, uint256, uint8);

    function getCurrentVote(string memory name) view public returns(int8, uint256);

    function voteForObjection(string memory name, bool wannaStop) public; 
}