// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ArtistPoolFormation {
    
    // Event to log the addition of a new artist to the pool
    event ArtistAdded(address indexed artistAddress, string artistName);
    
    // Event to log the removal of an artist from the pool
    event ArtistRemoved(address indexed artistAddress);
    
    // Event to log the selection of the first artist to start the marathon
    event FirstArtistSelected(address indexed artistAddress);
    
    // Struct to represent an artist
    struct Artist {
        address artistAddress;
        string artistName;
    }
    
    // Array to hold the artists
    Artist[] public artists;
    
    // Mapping to check if an artist is in the pool
    mapping(address => bool) public isArtistInPool;
    
    /**
     * @dev Adds a new artist to the pool.
     * @param _artistAddress The address of the artist to be added.
     * @param _artistName The name of the artist to be added.
     */
    function addArtist(address _artistAddress, string memory _artistName) external {
        require(!isArtistInPool[_artistAddress], "Artist already in pool");
        
        artists.push(Artist(_artistAddress, _artistName));
        isArtistInPool[_artistAddress] = true;
        
        emit ArtistAdded(_artistAddress, _artistName);
    }
    
    /**
     * @dev Removes an artist from the pool.
     * @param _artistAddress The address of the artist to be removed.
     */
    function removeArtist(address _artistAddress) external {
        require(isArtistInPool[_artistAddress], "Artist not in pool");
        
        // Find and remove the artist from the array
        for (uint i = 0; i < artists.length; i++) {
            if (artists[i].artistAddress == _artistAddress) {
                artists[i] = artists[artists.length - 1];
                artists.pop();
                break;
            }
        }
        
        isArtistInPool[_artistAddress] = false;
        
        emit ArtistRemoved(_artistAddress);
    }
    
    /**
     * @dev Selects the first artist randomly to start the marathon.
     * This function should only be callable once.
     */
    function selectFirstArtist() external {
        require(artists.length > 0, "No artists in pool");
        
        uint randomIndex = uint(keccak256(abi.encodePacked(block.timestamp))) % artists.length;
        address firstArtist = artists[randomIndex].artistAddress;
        
        emit FirstArtistSelected(firstArtist);
    }
    
    /**
     * @dev Gets the list of all artists in the pool.
     * @return An array of artist addresses.
     */
    function getAllArtists() external view returns (address[] memory) {
        address[] memory artistAddresses = new address[](artists.length);
        
        for (uint i = 0; i < artists.length; i++) {
            artistAddresses[i] = artists[i].artistAddress;
        }
        
        return artistAddresses;
    }
}
