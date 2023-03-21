// // SPDX-License-Identifier: MIT
// pragma solidity >=0.4.22 <0.9.0;

// import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
// import "@openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol";
// // import "./ERC1155Mintable.sol";
// // import "./ERC1155MetadataMintable.sol";
// // import "./ERC1155Metadata.sol";
// import
//  "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";


// contract ERC1155Full is ERC1155Supply, ERC1155Mintable, ERC1155MetadataMintable,ERC1155Metadata {

//     uint256 internal autoTokenId;
//     uint256[] internal autoTokenId1;

//       mapping(uint256 => address) private checkaddress;
//     constructor (string memory name, string memory symbol,bool _anyoneCanMint,string memory _uri)
//         ERC1155(_uri)  
//         ERC1155Mintable()
//         ERC1155Metadata(name,symbol){
//         // solhint-disable-previous-line no-empty-blocks

//         _setMintableOption(_anyoneCanMint);

//     }

//     // function exists(uint256 tokenId) public view returns (bool) {
//     //     return _exists(tokenId);
//     // }

//     // function tokensOfOwner(address owner) public view returns (uint256[] memory) {
//     //     return _tokensOfOwner(owner);
//     // }

//     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155, ERC165Storage) returns (bool) {
//         return super.supportsInterface(interfaceId);
//     }
//        function _beforeTokenTransfer(
//         address operator,
//         address from,
//         address to,
//         uint256[] memory ids,
//         uint256[] memory amounts,
//         bytes memory data)
//         internal
//         override(ERC1155, ERC1155Supply)
//     {
//         super._beforeTokenTransfer(operator,from, to, ids,amounts,data);
//     }

//     function setTokenURI(string memory uri) public {
//         _setURI(uri);
//     }

//     // /**
//     //  * @dev Function to mint tokens with automatic ID
//     //  * @param to The address that will receive the minted tokens.
//     //  * @return A boolean that indicates if the operation was successful.
//     //  */
//     function autoMint(
//         address to,
//         uint256 amount,
//         bytes memory data,
//         string memory tokenURI) internal onlyMinter returns (bool) {
//         do {
//             autoTokenId++;
//         } while(checkaddress[autoTokenId]  != address(0));
//         _mint(to, autoTokenId,amount, data);
//         _setURI( tokenURI);
//         return true;
//     }

//     function autoBatchMint(
//         address to,
//         uint256[] memory amounts,
//         bytes memory data,
//         string memory tokenURI) internal onlyMinter returns (bool) {
//             uint256 count;
//         do {
//             autoTokenId1[count + 1]  ;
//         } while(checkaddress[autoTokenId] != address(0));
//         _mintBatch(to, autoTokenId1,amounts, data);
//         _setURI( tokenURI);
//         return true;
//     }


   
//     function transfer(
//         address to,
//         uint256 tokenId,
//         uint256 amount,
//         bytes memory data
//     ) public {
//         safeTransferFrom(msg.sender, to, tokenId,amount,data);
//     }


//     function Batchtransfer(
//         address from,
//         address to,
//         uint256[] memory ids,
//         uint256[] memory amounts,
//         bytes memory data
//     ) public {
//         _safeBatchTransferFrom(from, to, ids, amounts, data);
//     }

// }