# Wedding-Contract

## Steps to use the wedding contract on Ropsten testnet:

1. Prepare the accounts:
- Husband and Wife:
    ```
    Khiem:
    Private key: BDF88CABD2299A9848D5CADCEAA4C7CA6770C45D64954A12E16D40ED86B41B03
    Public Address: 0xaFdAa0599D793DBB707Ea9eF24BdE16F8E691790

    Ngoc:
    B2CDEB1B1C8764BCAAA26CE17DE36C5C9C4F5FD2EB7DCABABD730C5484F9FC39
    0x78d96fAbAc0FB428566271184554c9520feA52Df
    ```

- Guests:
    ```
    Tolgahan:
    87AF62D336CA1945FE2046369389B48153783631B6B80956F3AC61F513BAFCE7
    0x5334a479fE305DB97fa7Bf496d17C9ccA7685eFa

    Arnab:
    3E625D6D4F36796778917EAF1142D7F7B5F7BDBBF6747885996FECF91D05AB55
    0x8b491cef0f4E881D5497A11CF92b577F5182da53

    Nam:
    09BCB2231547B2FDE0139326DE2AB3D1B15978C9314E9C0F6676B2CECA3620E0
    0x5457dFb8F9637b59Bed00A1C6A452841197D4f61

    Shamim:
    913BAC26813E133EB296822C362AF9FEC1C4515068D6754F0CF2AEE70EF80172
    0xDB282b79e4F8C5D9229d7A95Bf7960A9F9D5ED70
    ```

2. Deploy the contract:
- Husband or wife will deploy the contract.
- The input of constructor:
    ```
    "0x78d96fAbAc0FB428566271184554c9520feA52Df", "0xaFdAa0599D793DBB707Ea9eF24BdE16F8E691790", [["Nam", 0 ,0,0, "nam@gmail.com", "0x5457dFb8F9637b59Bed00A1C6A452841197D4f61"], ["Arnab", 0, 0, 0, "arnab@gmail.com","0x8b491cef0f4E881D5497A11CF92b577F5182da53"], ["Shamim", 0, 0, 0, "shamim@gmail.com","0xDB282b79e4F8C5D9229d7A95Bf7960A9F9D5ED70"], ["Tolgahan", 0, 0, 0, "tolgahan@gmail.com","0x5334a479fE305DB97fa7Bf496d17C9ccA7685eFa"]]
    ```

3. Deploy the guest API:
- Create a new file in the Remix and paste the GuestWeddingAPI.sol
- Switch to one guest account (e.g. Nam)

4. Interaction with functions:
- Accept Invitation:
    - Click the `acceptTheWedding` button with the input of the account holder name (e.g. `"Nam"`)
    - Get the ticket from `getGuestTicket` using the name of the account holder as input (e.g. `"Nam"`)
    - Get the wedding info from `getWeddingInfo` using the name of the account holder as input (e.g. `"Nam"`)
- Create Objection:
    - Switch to another account (e.g. Tolgahan)
    - Create one objection by clicking `opposeTheWedding` providing the reason and the name of the account holder (e.g. `"some reasons","Tolgahan"`)
- Objection Voting:
    - Switch to another account (e.g. Shamim)
    - Get objection status by clicking `getObjectionStatus` using the name (e.g. `"Shamim"`). If the status is in `PendingWithObjection`, any guest can vote execpt the husband, the wife and the person who post the objection.
    - To vote, click `voteForObjection` by providing the name and the opinion (e.g. `"Shamim",true`)
    - After voting, any guest can check the objection status with `getObjectionStatus`. It will show the following information:
        - reason
        - number of vote
        - total number of guest
        - objection threshold in percentage

5. Login on wedding day:
    - Switch to the guest account who accept the wedding invitation (e.g. Nam)
    - To log in, click `login` by providing the name and the ticket (e.g. `"Nam",3506840762`)
    - `NOTE: To satisfy the wedding day condition, you should adjust the weddingTimeStart and the weddingTimeEnd to your current day in the unix timestamp`. 

6. Complete the wedding
    - Switch to husband or wife account.
    - Click `completeTheWedding` to complete the wedding.
    - `NOTE: Both husband and wife need to click completeTheWedding to complete the wedding individually`.
    - For terminating the wedding:
        - Husband or wife can terminate the wedding by clicking `terminateTheWedding`.

