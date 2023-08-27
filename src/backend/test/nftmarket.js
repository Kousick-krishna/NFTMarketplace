const {expect } = require('chai');

describe("Nftmarketplace", async function(){

    let nft;
    let NFT;
    let Marketplace;
    let marketplace;
    let deployer;
    let addr1;
    let addr2;
    let feepercent;

    beforeEach(async function(){
        NFT = await ethers.getContractFactory("NFT");
        Marketplace = await ethers.getContractFactory("Marketplace");
        nft = await NFT.deploy();
        marketplace = await Marketplace.deploy(feepercent);

        [deployer, addr1, addr2] = ethers.getSigners();

        describe("Deployment", async function(){
            it("Should return name and symbol of the token", async function(){
                const nftname = "IERC721";
                const nftsymbol = "KK";
                expect(await nft.name()).to.equal(nftname);
                expect(await nft.symbol()).to.equal(nftsymbol);

            });
        })
        
    })
})  