pragma solidity >=0.4.0 <0.7.0;
//pragma experimental ABIEncoderV2;
contract Wedding{
    string eventName;
    string husbandName;
    string wifeName;
    string location;
    string weddingStatus; //{Pending / Completed / Terminated }
    uint256 weddingTime;
    string objectionStatus;
    struct Guest{
        string name;
        string email;
        uint256 couponCode;
        uint256 ticket;
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
        // object = NULL; 
    }
    function createGuestList() private returns(Guest[] storage){
      // create new user
      // add to array
      Guest memory newGuest=Guest({name: "Arnab", ticket: NULL, couponCode: NULL,  email: "arnab@gmail.com", etherumAddress: 0x81549c1746d2Ce0ACd15470104EBc62B7a104fa6, decision: false});
      listOfGuest.push(newGuest);
      newGuest=Guest({name: "Nam", ticket: NULL, couponCode: NULL,  email: "nam@gmail.com", etherumAddress: 0x671afec674940d292804Ecfd7A2AeAbE2bD3f1a0, decision: false});
      listOfGuest.push(newGuest);
      newGuest=Guest({name: "Shamim", ticket: NULL, couponCode: NULL,  email: "shamim@gmail.com", etherumAddress: 0x671afec674940d292804Ecfd7A2AeAbE2bD3f1a0, decision: false});
      listOfGuest.push(newGuest);
      return listOfGuest;
    }
    // function getGuestList() view public returns(Guest[]){
    //   return listOfGuest;
    // }
    //function createGuestList() private returns (Guest[]);
    //function authenticate(string name, string code) private;
    //function ticketGeneration() private;
    //function couponGeneration() private;
    //function accept(string name, string couponCode) public;
    //function reject(string name, string couponCode) public;
    //function login(string name, string ticket) public;
    //function opposeWedding(string reason, string name, string couponCode ) public; // check objectionStatus
    ////------------------------------------------------ Optional part-----------------------------------
    //function objectionVoting(string name, string couponCode, bool wannaStop) public;
}
