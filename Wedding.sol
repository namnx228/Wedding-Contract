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
    enum WeddingStatus {
        Pending,
        Completed,
        Terminated,
        PendingWithObjection
    }

    string eventName;
    string coupleName;
    string location;
    WeddingStatus weddingStatus; //{Pending / Completed / Terminated / PendingWithObjection }
    uint weddingTimeStart;
    uint weddingTimeEnd;
    address coupleAddress;
    address coupleAddress2;    

    mapping (string => uint256) ticketMapping;
    mapping (string => uint256) couponMapping;
    mapping (string => bool) participationRecord;
    mapping (uint256 => int8) votingData;
    string private constant ticket = "123yc346tb349v3";
    uint paticipantCount;
    
    Guest[] listOfGuest;
    
    ObjectionStatus objectionStatus = ObjectionStatus.None;
    Objection object;
    uint8 objectionVotingThreshold;
    mapping (address => string) address2name;
    mapping (string => uint) name2index;
    address wifeAddress;
    address husbandAddress;

    constructor(Guest[] memory guestList ) public {
        eventName = "Khiem - Ngoc wedding";
        // husbandName = "Khiem";
        // wifeName = "Ngoc";
        coupleName = "Khiem - Ngoc";
        location = "WC";
        weddingStatus = WeddingStatus.Pending;
        
        weddingTimeStart = 1571961600; // 10/25/2019 -- 0:0:0
        weddingTimeEnd = 1572307200; // 10/29/2019 -- 0:0:0
        paticipantCount = 0;
        
        //coupleAddress = 0x86CEfcde6fb206629ea9D064Df31836EF1D1D648;
        
        coupleAddress = 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c; // Test address;
        wifeAddress = 0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB;
        husbandAddress = 0x583031D1113aD414F02576BD6afaBfb302140225;
        // coupleAddress2 = 0xdD870fA1b7C4700F2BD7f44238821C26f7392148;
        
        for(uint i = 0; i < guestList.length; i++){
            listOfGuest.push(guestList[i]);
            // name2address[guestList[i].name] = gue
            address2name[guestList[i].etherumAddress] = guestList[i].name;
            name2index[guestList[i].name] = i;
        }
        
        ticketGeneration();

        // couponGeneration();
        
        
        objectionVotingThreshold = 50;
    }
    modifier checkWeddingStage(WeddingStatus expectedWeddingStatus, string memory message){
      require(expectedWeddingStatus == weddingStatus, message);
      _;
    }

    modifier checkParticipationRecord(string memory name, string memory message){
        require(participationRecord[name] == false, message);
        _;
    }

    modifier isBigDay(){
        uint timestamp=block.timestamp;
      require(weddingTimeStart <= block.timestamp && block.timestamp <= weddingTimeEnd, "Today is not the bigday");
      _;
    }

    modifier authenticate(string memory name, string memory message){
      require(compareStrings(address2name[msg.sender], name), message);
      _;
      // require(address2name[msg.sender] == name);
    }
    
    function getGuest(string  memory guestname, int256  guestticket) view private returns (int){
      for (uint i = 0; i < listOfGuest.length; i++){
        string memory tmpName = listOfGuest[i].name;
        uint tmpTicket = listOfGuest[i].ticket;
        if (compareStrings(tmpName, guestname) &&  tmpTicket ==  uint(guestticket)){
          return int(i);
        }
      }
      return -1;
    }

    //function checkAddress(address senderAddress, uint index) view public returns(bool){
    ////function login(string name, uint256 ticket) public {
    //  if (senderAddress == listOfGuest[index].etherumAddress){
    //    // if the guest don't have account or they use the registered address to pay for the transaction then TRUE
    //    return true;
    //  }
    //  return false;
    //}
    
    function checkIn(string memory guestname, int256 guestticket) view private returns(bool){
       int guestIndex = getGuest(guestname, guestticket);
       if (guestIndex == -1 )
         return false;
       return true;
    }

    function login(string memory guestname, int256  guestticket) checkWeddingStage(WeddingStatus.Pending, "Go out") 
                  isBigDay
                  authenticate(guestname,"This address is not allowed to be involed in this contract" ) view public returns (string memory){
       if (checkIn(guestname, guestticket))
          return "Welcome to the wedding";
       return "You don't have the ticket or you are not invited";
    }
    
    
    // Accept function
    function accept(string memory name) 
        checkWeddingStage(WeddingStatus.Pending,"You are not allowed to accept the invitation anymore.") 
        checkParticipationRecord(name,"You have already confirmed whether you will participate or not.")
        authenticate(name, "This address is not allowed to join the contract") public {
        // hash provided name
        //uint256 providedName = uint256(sha256(abi.encodePacked(name)));
        //int matched = authenticate(providedName, couponCode);
        //int matched = authenticate(name);
        // if (!checkAddress(msg.sender, uint(matched)))
        //   return ;
        //if (matched != -1){
            // listOfGuest[uint256(matched)].decision = true;
            uint index = name2index[name];
            ticketMapping[name] = listOfGuest[uint256(index)].ticket;
            participationRecord[name] = true;
            paticipantCount++;
            
            //ticketMapping[providedName] = listOfGuest[uint256(matched)].ticket;
            //return listOfGuest[uint256(matched)].ticket;
            //return guestTicket(uint256(matched));
        //}
    }
    // num of paticipants
    // status of wedding
    // Date of the wedding
    // Name of the couple
    // Location
    //mapping (string => string) title2value;
    //struct Info{
    //    string title;
    //    string value;
    //}
    ////Info[] memory info;
    //function weddingInfo() view public returns (Info[2] memory){
    // // Info = new Info[5];
    //  Info[2] memory info;
    //  info[0].title = "Number of paticipants"; info[0].value = string(paticipantCount);
    //  info[1].title = "Name of"; info[1].value = "naasdsf";
    //  return info;
    //}

    function weddingInfo() authenticate()view public returns(string memory, string memory, //Name of the couple
                                               string memory, string memory, // Location
                                               string memory, string memory, // Date
                                               string memory, uint, // Num of paticipant
                                               string memory, string memory){ // Status
        //mapping (string => string) storage title2value;
        //title2value["Name of the couple"] = coupleName;
        //return title2value;
       // info memory testInfo;
       // testInfo.title = "Title";
       // testInfo.value = "value";
       return ("Name of the couple: ", coupleName, 
              "Location: ", location, 
              "Date: ", "11/04/2019",
              "Number of paticipants: ", paticipantCount,
              "Status of the wedding: ", getWeddingStatus() );

    }

    // Reject function
    //function reject(string memory name, uint256 couponCode) 
    //    checkWeddingStage(WeddingStatus.Pending,"You are not allowed to accept the invitation anymore.") 
    //    checkParticipationRecord(name,"You have already confirmed whether you will participate or not.") public {
    //    // hash provided name
    //    //uint256 providedName = uint256(sha256(abi.encodePacked(name)));
    //    int matched = authenticate(name, couponCode);
    //    if (!checkAddress(msg.sender, uint(matched)))
    //      return ;
    //    if (matched != -1){
    //        listOfGuest[uint256(matched)].decision = false;
    //        participationRecord[name] = true;
    //    }
    //}
    
    // Authentication (Accept/Reject)
    //function authenticate(string memory name) private view returns (int){
    //    for (uint8 i=0; i<listOfGuest.length; i++){
    //        //uint256 guestName = uint256(sha256(abi.encodePacked(listOfGuest[i].name)));
    //        if(compareStrings(name, listOfGuest[i].name) && (listOfGuest[i].etherumAddress == msg.sender)){
    //            return i;
    //        }
    //    }
    //    return -1;
    //}

    // ticket generation
    function ticketGeneration() private {
        for (uint256 i = 0; i < listOfGuest.length ; i++){
            //uint256 providedName = uint256(sha256(abi.encodePacked(listOfGuest[i].name)));
            listOfGuest[i].ticket = random(i,"ticket");
            //ticketMapping[providedName] = listOfGuest[i].ticket;
        }
    }
    
    
    // coupon generation
    //function couponGeneration() private {
    //    for (uint256 i = 0; i < listOfGuest.length ; i++){
    //        //uint256 providedName = uint256(sha256(abi.encodePacked(listOfGuest[i].name)));
    //        listOfGuest[i].couponCode = random(i,"coupon");
    //        couponMapping[listOfGuest[i].name] = listOfGuest[i].couponCode;
    //    }
    //}

     function getGuestList() view public returns(Guest[] memory){
       return listOfGuest;

    }
    function getWeddingStatus() view public returns (string memory){
      if (weddingStatus == WeddingStatus.Pending)
        return "Pending";
      if (weddingStatus == WeddingStatus.Completed)
        return "Completed";

      return "Terminated";
    }

    // show guest ticket details
    function guestTicket(string memory name) view public returns (uint256){
        //uint256 providedName = uint256(sha256(abi.encodePacked(name)));
        return ticketMapping[name];
    }
    
    // show guest coupon details
    //function guestCoupon(string memory name) view public returns (uint256){
    //    //uint256 providedName = uint256(sha256(abi.encodePacked(name)));
    //    return couponMapping[name];
    //}
    
    // random number generation
    function random(uint256 index, string memory ticket_coupon) private view returns (uint32) {
        //return uint32(sha256(block.timestamp) % 4294967295);
        string memory guestName = listOfGuest[index].name;
        //return uint32(uint256(sha256(listOfGuest[index].name)) % 4294967295);
        return uint32(uint256(sha256(abi.encodePacked(ticket_coupon, guestName))) % 4294967295);
    }

    function opposeWedding(string memory reason, string memory name) 
                          authenticate(name, "Relax, there has been arealdy an objection, do you like to vote?")public {
        // int matched = authenticate(name, couponCode);
        
        // if (checkAddress(msg.sender, uint(matched))) {
            require(objectionStatus == ObjectionStatus.None, "Relax, there has been arealdy an objection, do you like to vote?");
            
            uint256 providedName = uint256(sha256(abi.encodePacked(name)));
            object = Objection({reason: reason, postedPersonName: name, objectionDate: now, numOfPositiveVote: 1});
            
            votingData[providedName] = 1;
            if (object.numOfPositiveVote * 100 / listOfGuest.length > objectionVotingThreshold) {
                objectionStatus = ObjectionStatus.Completed;
                weddingStatus = WeddingStatus.Terminated;
                return;
            } else {
                objectionStatus = ObjectionStatus.Pending;
                weddingStatus = WeddingStatus.PendingWithObjection;    
            }
            
        // }
    }
    
    function getObjectionStatus(string memory name) 
                                authenticate(name, "You cannot vote with wrong credential") public view returns (string memory, string memory, uint256){
        // int matched = authenticate(name, couponCode);
        
        // if (checkAddress(msg.sender, uint(matched))) {
            // uint256 providedName = uint256(sha256(abi.encodePacked(name)));
            
            if (objectionStatus == ObjectionStatus.Pending) {
                return ("Pending Objection", object.reason, object.numOfPositiveVote);
            } else if (objectionStatus == ObjectionStatus.Rejected) {
                return ("Rejected Objection, Everything is still good!", object.reason, object.numOfPositiveVote);
            } else if (objectionStatus == ObjectionStatus.Completed) {
                return ("Completed Objection, DONE!", object.reason, object.numOfPositiveVote);
            }
            return ("Everything is still good, I guess!", "", 0);
        // }
        
        return ("Hello outsider, thank you for playing with us!", "", 0);
    }
    
    modifier checkCoupleAddress(){
      require(weddingStatus == WeddingStatus.Pending || weddingStatus == WeddingStatus.PendingWithObjection, "Wedding ceremony is not happening");
      require(block.timestamp > weddingTimeEnd, "Too soon to complete the wedding");
      require(msg.sender == coupleAddress, "You cannot complete the wedding using this address");
      _;
    }
    
    function completeTheWedding() checkCoupleAddress public{
        weddingStatus = WeddingStatus.Completed;
    }

    function getCurrentVote(string memory name) 
                            authenticate(name, "You cannot vote with wrong credential") view public returns(int8, uint256) {
        // int matched = authenticate(name, couponCode);
        
        // if (checkAddress(msg.sender, uint(matched))) {
            uint256 providedName = uint256(sha256(abi.encodePacked(name)));
            return (votingData[providedName], object.numOfPositiveVote);
        // }
        return (0,0);
    }

    // function terminate()  public {
    //   require();

    // }
   
    function objectionVoting(string memory name, bool wannaStop)
                              authenticate(name, "You cannot vote with wrong credential") public {            
        // int matched = authenticate(name, couponCode);
        
        // if (checkAddress(msg.sender, uint(matched))) {

            require(objectionStatus == ObjectionStatus.Pending, "There must be an objection created or not yet terminated to be able to vote!");
            
            uint256 providedName = uint256(sha256(abi.encodePacked(name)));
            int8 currentVote = votingData[providedName];
            if (wannaStop) {
                votingData[providedName] = 1;
                if (currentVote != 1) {
                    object.numOfPositiveVote += 1;
                }
            } else {
                votingData[providedName] = -1;
                if (currentVote != -1) {
                    object.numOfPositiveVote -= 1;
                }
            }
            
            if (object.numOfPositiveVote * 100 / listOfGuest.length > objectionVotingThreshold) {
                weddingStatus = WeddingStatus.Terminated;
                objectionStatus = ObjectionStatus.Completed;
            }
        // }
    }

    ////------------------------------------------------ Utility Functions -----------------------------------
    function compareStrings (string memory a, string memory b) private view returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))) );
    }
}






