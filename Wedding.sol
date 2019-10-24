pragma solidity >=0.4.0 <0.7.0;
contract Wedding{
    string eventName;
    string husbandName;
    string wifeName;
    string location;
    string weddingStatus; //{Pending / Completed / Terminated }
    uint256 weddingTime;
    string objectionStatus;
    string private constant ticket = "123yc346tb349v3";
    struct Guest{
        string name;
        string email;
        string couponCode;
        string ticket;
        bool decision;
        address etherumAddress;
    }
    struct Objection{
        string reason;
        string postedPersonName;
        uint256 objectionDate;
        uint8 numOfVote;
    }
    Guest[] listOfGuest;
    Objection object;
    uint256 constant NULL = uint256(0);
    constructor() public {
        eventName = "Khiem - Ngoc wedding";
        husbandName = "Khiem";
        wifeName = "Ngoc";
        location = "WC";
        weddingStatus = "Pending";
        weddingTime = 1572047999;
        listOfGuest = createGuestList();
        object = NULL; 
    }
    function createGuestList() private return(Guest[] memory guestList){
      // create new user
      // add to array
      Guest memory newGuest=Guest({name: "Arnab", ticket: ticket, email: "arnab@gmail.com", address: 0x81549c1746d2Ce0ACd15470104EBc62B7a104fa6});
      guestList.push();
      Guest memory newGuest=Guest({name: "Nam", ticket: ticket, email: "nam@gmail.com", address: 0x671afec674940d292804Ecfd7A2AeAbE2bD3f1a0});
      guestList.push();
      return guestList;
    }
    function createGuestList() private;
    function authenticate(string name, string code) private;
    function ticketGeneration() private;
    function accept(string name, string couponCode) public;
    function reject(string name, string couponCode) public;
    function login(string name, string ticket) public;
    function opposeWedding(string reason, string name, string couponCode ) public; // check objectionStatus
    //------------------------------------------------ Optional part-----------------------------------
    function objectionVoting(string name, string couponCode, bool wannaStop) public;
}
