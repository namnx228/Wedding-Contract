pragma experimental ABIEncoderV2;
pragma solidity >=0.4.0 <0.7.0;
contract Wedding{
    string eventName;
    string husbandName;
    string wifeName;
    string location;
    string weddingStatus; //{Pending / Completed / Terminated }
    uint256 weddingTimeStart;
    uint256 weddingTimeEnd;
    string objectionStatus;
    address coupleAddress;

    mapping (uint256 => uint256) public ticketMapping;
    mapping (uint256 => uint256) public couponMapping;
    string private constant ticket = "123yc346tb349v3";

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
    /*
    constructor() public {
        eventName = "Khiem - Ngoc wedding";
        husbandName = "Khiem";
        wifeName = "Ngoc";
        location = "WC";
        weddingStatus = "Pending";
        weddingTimeStart = 1572010575; // 10/25/2019 -- 0:0:0
        weddingTimeEnd = 1572010620; // 10/26/2019 -- 0:0:0
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
=======
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
        weddingTimeStart = 1571961600; // 10/25/2019 -- 0:0:0
        weddingTimeEnd = 1572048000; // 10/26/2019 -- 0:0:0
        //coupleAddress = 0x86CEfcde6fb206629ea9D064Df31836EF1D1D648;
        coupleAddress = 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c; // Test address;
        for(uint i = 0; i < guestList.length; i++){
            listOfGuest.push(guestList[i]);
        }
        
        ticketGeneration();
        couponGeneration();
    }
    modifier checkWeddingStage(string memory expectedWeddingStatus){
      require(compareStrings(expectedWeddingStatus, weddingStatus), "The wedding has been completed");
      _;
    }
    modifier isBigDay(){
        uint timestamp=block.timestamp;
      require(weddingTimeStart <= block.timestamp && block.timestamp <= weddingTimeEnd, "Today is not the bigday");
      _;
    }
    function getGuestIndex(string  memory guestname, int256  guestticket) view private returns(int){
      for (uint i = 0; i < listOfGuest.length; i++){
        string memory tmpName = listOfGuest[i].name;
        uint tmpTicket = listOfGuest[i].ticket;
        if (compareStrings(tmpName, guestname) &&  tmpTicket ==  uint(guestticket)){
          return int(i);
        }
      }
      return -1;
    }
    function checkAddress(address senderAddress, uint index) view public returns(bool){
      
      if (senderAddress ==  coupleAddress || senderAddress == listOfGuest[index].etherumAddress){
        // if the guest don't have account or they use the registered address to pay for the transaction then TRUE
        return true;
      }
      return false;
    }
    

    function login(string memory guestname, int256  guestticket) checkWeddingStage("Pending") isBigDay view public returns (string memory){
       int guestIndex = getGuestIndex(guestname, guestticket);
       if (guestIndex == -1 )
         return "You don't have the ticket or you are not invited";
       if (!checkAddress(msg.sender, uint(guestIndex))){
         return "This address is not allowed to be involed in this contract";
       }
       return "Welcome to the wedding";
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
    function accept(string memory name, uint256 couponCode) checkWeddingStage("Pending") public {
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
            }
        }
        return -1;
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

    function compareStrings (string memory a, string memory b) view private returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))) );
    }
}





