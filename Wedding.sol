pragma experimental ABIEncoderV2;
pragma solidity >=0.4.0 <0.7.0;
contract Wedding{
    uint256 constant NULL = uint256(0);

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

    string eventName;
    string husbandName;
    string wifeName;
    string location;
    string weddingStatus; //{Pending / Completed / Terminated }
    uint256 weddingTime;

    mapping (uint256 => uint256) ticketMapping;
    mapping (uint256 => uint256) couponMapping;
    string private constant ticket = "123yc346tb349v3";
    
    Guest[] listOfGuest;
    
    string objectionStatus;
    Objection object;

    /*
    constructor() public {
        eventName = "Khiem - Ngoc wedding";
        husbandName = "Khiem";
        wifeName = "Ngoc";
        location = "WC";
        weddingStatus = "Pending";
        weddingTime = 1572047999;
        createGuestList();
        ticketGeneration();
        couponGeneration();
        //object = NULL;
    }
    
    function createGuestList() private {
      // create new user
      // add to array
      //Guest[] memory guestList;
      Guest memory newGuest=Guest({couponCode: NULL, decision: true, name: "Arnab", ticket: NULL, email: "arnab@gmail.com", etherumAddress: 0x81549c1746d2Ce0ACd15470104EBc62B7a104fa6});
      listOfGuest.push(newGuest);
      newGuest=Guest({couponCode: NULL, decision: true, name: "Nam", ticket: NULL, email: "nam@gmail.com", etherumAddress: 0x671afec674940d292804Ecfd7A2AeAbE2bD3f1a0});
      listOfGuest.push(newGuest);
    }
    
    //function createGuestList() private returns (Guest[]);
    //function authenticate(string name, string code) private;
    //function ticketGeneration() public;
    //function couponGeneration() private;
    //function accept(string name, string couponCode) public;
    //function reject(string name, string couponCode) public;
    //function login(string name, string ticket) public;
    //function opposeWedding(string reason, string name, string couponCode ) public; // check objectionStatus
    //------------------------------------------------ Optional part-----------------------------------
    //function objectionVoting(string name, string couponCode, bool wannaStop) public;
    

    // Accept function
    function accept(string memory name, uint256 couponCode) public {
        // hash provided name
        uint256 providedName = uint256(sha256(abi.encodePacked(name)));

        int matched = authenticate(providedName, couponCode);
        if (matched != -1){
            listOfGuest[uint256(matched)].decision = true;
            ticketMapping[providedName] = listOfGuest[uint256(matched)].ticket;
            //return listOfGuest[uint256(matched)].ticket;
            //return guestTicket(uint256(matched));
        listOfGuest = createGuestList();
        // object = NULL; 
    }
    */
    constructor(Guest[] memory guestList ) public {
        eventName = "Khiem - Ngoc wedding";
        husbandName = "Khiem";
        wifeName = "Ngoc";
        location = "WC";
        weddingStatus = "Pending";
        weddingTime = 1572047999;
        for(uint i = 0; i < guestList.length; i++){
            listOfGuest.push(guestList[i]);
        }
        ticketGeneration();
        couponGeneration();
    }
    // function createGuestList() private returns(Guest[] storage){
    //   // create new user
    //   // add to array
    //   Guest memory newGuest=Guest({name: "Arnab", ticket: NULL, couponCode: NULL,  email: "arnab@gmail.com", etherumAddress: 0x81549c1746d2Ce0ACd15470104EBc62B7a104fa6, decision: false});
    //   listOfGuest.push(newGuest);
    //   newGuest=Guest({name: "Nam", ticket: NULL, couponCode: NULL,  email: "nam@gmail.com", etherumAddress: 0x671afec674940d292804Ecfd7A2AeAbE2bD3f1a0, decision: false});
    //   listOfGuest.push(newGuest);
    //   newGuest=Guest({name: "Shamim", ticket: NULL, couponCode: NULL,  email: "shamim@gmail.com", etherumAddress: 0x671afec674940d292804Ecfd7A2AeAbE2bD3f1a0, decision: false});
    //   listOfGuest.push(newGuest);
    //   return listOfGuest;
    // }
    
    // Accept function
    function accept(string memory name, uint256 couponCode) public {
        // hash provided name
        uint256 providedName = uint256(sha256(abi.encodePacked(name)));

        int matched = authenticate(providedName, couponCode);
        if (matched != -1){
            listOfGuest[uint256(matched)].decision = true;
            ticketMapping[providedName] = listOfGuest[uint256(matched)].ticket;
            //return listOfGuest[uint256(matched)].ticket;
            //return guestTicket(uint256(matched));
        }
    }

    // Reject function
    function reject(string memory name, uint256 couponCode) public {
        // hash provided name
        uint256 providedName = uint256(sha256(abi.encodePacked(name)));
        int matched = authenticate(providedName, couponCode);
        if (matched != -1){
            listOfGuest[uint256(matched)].decision = false;
        }
    }
    
    // Authentication (Accept/Reject)
    function authenticate(uint256 namehash, uint256 code) private view returns (int){
        for (uint8 i=0; i<listOfGuest.length; i++){
            uint256 guestName = uint256(sha256(abi.encodePacked(listOfGuest[i].name)));
            if((namehash == guestName) && (listOfGuest[i].couponCode == code)){
                return i;
            }else{
                return -1;
            }
        }
    }

    // ticket generation
    function ticketGeneration() private {
        for (uint256 i = 0; i < listOfGuest.length ; i++){
            //uint256 providedName = uint256(sha256(abi.encodePacked(listOfGuest[i].name)));
            listOfGuest[i].ticket = random(i,"ticket");
            //ticketMapping[providedName] = listOfGuest[i].ticket;
        }
    }
    
    // coupon generation
    function couponGeneration() private {
        for (uint256 i = 0; i < listOfGuest.length ; i++){
            uint256 providedName = uint256(sha256(abi.encodePacked(listOfGuest[i].name)));
            listOfGuest[i].couponCode = random(i,"coupon");
            couponMapping[providedName] = listOfGuest[i].couponCode;
        }
    }

     function getGuestList() view public returns(Guest[] memory){
       return listOfGuest;

    }

    // show guest ticket details
    function guestTicket(string memory name) view public returns (uint256){
        uint256 providedName = uint256(sha256(abi.encodePacked(name)));
        return ticketMapping[providedName];
    }
    
    // show guest coupon details
    function guestCoupon(string memory name) view public returns (uint256){
        uint256 providedName = uint256(sha256(abi.encodePacked(name)));
        return couponMapping[providedName];
    }
    
    // random number generation
    function random(uint256 index, string memory ticket_coupon) private view returns (uint32) {
        //return uint32(sha256(block.timestamp) % 4294967295);
        string memory guestName = listOfGuest[index].name;
        //return uint32(uint256(sha256(listOfGuest[index].name)) % 4294967295);
        return uint32(uint256(sha256(abi.encodePacked(ticket_coupon, guestName))) % 4294967295);
    }
    
    function opposeWedding(string reason, string name, string couponCode) public {
    }


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


