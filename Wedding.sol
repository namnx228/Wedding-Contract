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
        uint256 numOfPositiveVote;
    }
    enum ObjectionStatus {
        None,
        Pending,
        Completed,
        Rejected // We may need this someday!?
    }


    string eventName;
    string husbandName;
    string wifeName;
    string location;
    string weddingStatus; //{Pending / Completed / Terminated / PendingWithObjection }
    uint256 weddingTime;

    mapping (string => uint256) ticketMapping;
    mapping (string => uint256) couponMapping;
    mapping (string => bool) participationRecord;
    mapping (uint256 => int8) votingData;
    string private constant ticket = "123yc346tb349v3";
    
    Guest[] listOfGuest;
    
    ObjectionStatus objectionStatus = ObjectionStatus.None;
    Objection object;
    uint8 objectionVotingThreshold;

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
        
        objectionVotingThreshold = 5;
    }
    modifier checkWeddingStage(string memory expectedWeddingStatus, string memory message){
      require(compareStrings(expectedWeddingStatus, weddingStatus), message);
      _;
    }
    
    modifier checkParticipationRecord(string memory name, string memory message){
        require(participationRecord[name] == false, message);
        _;
    }
    
    
    //function login(string name, uint256 ticket) public {
      
      // int guestIndex = getGuestIndex(name, ticket);
      // accept(name, 0 );

      // check if user has address ?

    //}
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
    function accept(string memory name, uint256 couponCode) 
        checkWeddingStage("Pending","You are not allowed to accept the invitation anymore.") 
        checkParticipationRecord(name,"You have already confirmed whether you will participate or not.") public {
        // hash provided name
        //uint256 providedName = uint256(sha256(abi.encodePacked(name)));
        //int matched = authenticate(providedName, couponCode);
        int matched = authenticate(name, couponCode);
        if (matched != -1){
            listOfGuest[uint256(matched)].decision = true;
            ticketMapping[name] = listOfGuest[uint256(matched)].ticket;
            participationRecord[name] = true;
            //ticketMapping[providedName] = listOfGuest[uint256(matched)].ticket;
            //return listOfGuest[uint256(matched)].ticket;
            //return guestTicket(uint256(matched));
        }
    }

    // Reject function
    function reject(string memory name, uint256 couponCode) 
        checkWeddingStage("Pending","You are not allowed to accept the invitation anymore.") 
        checkParticipationRecord(name,"You have already confirmed whether you will participate or not.") public {
        // hash provided name
        //uint256 providedName = uint256(sha256(abi.encodePacked(name)));
        int matched = authenticate(name, couponCode);
        if (matched != -1){
            listOfGuest[uint256(matched)].decision = false;
            participationRecord[name] = true;
        }
    }
    
    // Authentication (Accept/Reject)
    function authenticate(string memory name, uint256 code) private returns (int){
        for (uint8 i=0; i<listOfGuest.length; i++){
            //uint256 guestName = uint256(sha256(abi.encodePacked(listOfGuest[i].name)));
            if(compareStrings(name, listOfGuest[i].name) && (listOfGuest[i].couponCode == code)){
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
            //uint256 providedName = uint256(sha256(abi.encodePacked(listOfGuest[i].name)));
            listOfGuest[i].couponCode = random(i,"coupon");
            couponMapping[listOfGuest[i].name] = listOfGuest[i].couponCode;
        }
    }

     function getGuestList() view public returns(Guest[] memory){
       return listOfGuest;

    }

    // show guest ticket details
    function guestTicket(string memory name) view public returns (uint256){
        //uint256 providedName = uint256(sha256(abi.encodePacked(name)));
        return ticketMapping[name];
    }
    
    // show guest coupon details
    function guestCoupon(string memory name) view public returns (uint256){
        //uint256 providedName = uint256(sha256(abi.encodePacked(name)));
        return couponMapping[name];
    }
    
    // random number generation
    function random(uint256 index, string memory ticket_coupon) private view returns (uint32) {
        //return uint32(sha256(block.timestamp) % 4294967295);
        string memory guestName = listOfGuest[index].name;
        //return uint32(uint256(sha256(listOfGuest[index].name)) % 4294967295);
        return uint32(uint256(sha256(abi.encodePacked(ticket_coupon, guestName))) % 4294967295);
    }

    function opposeWedding(string memory reason, string memory name, uint256 couponCode) public {
        require(objectionStatus == ObjectionStatus.None, "Relax, there has been arealdy an objection, do you like to vote?");
        
        uint256 providedName = uint256(sha256(abi.encodePacked(name)));
        if (authenticate(providedName, couponCode) != -1) {
            object = Objection({reason: reason, postedPersonName: name, objectionDate: now, numOfPositiveVote: 1});
            
            votingData[providedName] = 1;
            if (object.numOfPositiveVote / listOfGuest.length > objectionVotingThreshold) {
                objectionStatus = ObjectionStatus.Completed;
                weddingStatus = "Terminated";
                return;
            } else {
                objectionStatus = ObjectionStatus.Pending;
                weddingStatus = "PendingWithObjection";    
            }
            
        }
    }
    
    function getObjectionStatus(string memory name, uint256 couponCode) public view returns (string memory, string memory, uint256){
        uint256 providedName = uint256(sha256(abi.encodePacked(name)));
        if (authenticate(providedName, couponCode) != -1) {
            if (objectionStatus == ObjectionStatus.Pending) {
                return ("Pending Objection", object.reason, object.numOfPositiveVote);
            } else if (objectionStatus == ObjectionStatus.Rejected) {
                return ("Rejected Objection, Everything is still good!", object.reason, object.numOfPositiveVote);
            } else if (objectionStatus == ObjectionStatus.Completed) {
                return ("Completed Objection, DONE!", object.reason, object.numOfPositiveVote);
            }
            return ("Everything is still good, I guess!", "", 0);
        }
        
        return ("Hello outsider, thank you for playing with us!", "", 0);
    }
   
    function objectionVoting(string memory name, uint256 couponCode, bool wannaStop) public {            
        require(objectionStatus == ObjectionStatus.Pending, "There must be an objection created or not yet terminated to be able to vote!");
        
        uint256 providedName = uint256(sha256(abi.encodePacked(name)));
        if (authenticate(providedName, couponCode) != -1) {
            int8 currentVote = votingData[providedName];
            if (wannaStop) {
                votingData[providedName] = 1;
                if (currentVote == -1) {
                    object.numOfPositiveVote += 1;
                }
            } else {
                votingData[providedName] = -1;
                if (currentVote == 1) {
                    object.numOfPositiveVote -= 1;
                }
            }
            
            if (object.numOfPositiveVote / listOfGuest.length > objectionVotingThreshold) {
                weddingStatus = "Terminated";
                objectionStatus = ObjectionStatus.Completed;
            }
        }
    }

    ////------------------------------------------------ Utility Functions -----------------------------------
    function compareStrings (string memory a, string memory b) private returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))) );
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