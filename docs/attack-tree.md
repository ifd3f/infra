# Attack Trees

### Definitions of flags:

- E = easy
- M = medium
- H = hard
- I = (currently) impossible
- P = requires physical access

All branches are (OR) unless explicitly specified.

## Encrypted ZFS volume attack tree

Goal: Decrypt an encrypted ZFS volume
  - Determine passphrase (M)
    - Brute-force (H)
      - Gain access to the volume (P)
    - Blackmail (M)
    - Threaten (M)
    - Steal keys from Bitwarden (Bitwarden attack tree)
  - Determine encryption key (I)
    - Cryptanalysis of AES-256 (I)
    - Brute-force (IP)
  - Install a hardware keylogger between my keyboard and machine as I enter in my password (P)
  - Cold boot attack to extract ZFS key (HP)

## The infra repo

Goal: Submit a compromised configuration to the infra repo without getting caught
  - Compromise my Github account
    - Extract astrid's SSH key
    - Extract astrid's PAT
      - Compromise a laptop
    - Hack into Github
  - Sneak it in a pull request
    - Make it hard for me to detect
      - Use a bug in Nix
      - Drug me and convince me to review the pull request
      - Approve the pull request on my login
        - Compromise my Github account
        - Do it while I'm looking away (P)
    - Compromise Github to add the attacker as a collaborator to approve and merge

## Acquiring a Linux user password

Goal: Get a Linux user password
  - Acquire hashes
    - Decrypt disk (AND)
    - Brute-force the hashes (H)
  - Brute-force in a regular shell with delays (I)
  - Blackmail (M)
  - Threaten (M)

## Banana Laptop

Goal: Compromise root user
  - Ensure the the disk is decrypted (AND)
    - Compromise disk so that you can even log in to begin with
      - (ZFS volume attack tree)
    - Attack while the computer is powered and in use
      - Compromise a jump server
      - Compromise internal server
        - Compromise the infra repo
  - Boot into single-user mode
    - Determine root password
      - Extract from Bitwarden
      - Brute-force
      - Threaten
      - Blackmail
  - Use sudo
    - Gain access to a sudo session
      - Get access to a sudoer, such as astrid@banana
        - Gain access to astrid@banana (AND)
        - Determine the password
          - Brute-force
          - Blackmail
          - Threaten
        - Drop in after a sudoer runs a sudo command and it remembers the password for a bit
      - Gain access to a non-sudo user account
        - Find a sudo vulnerability (AND)
          - Hack sudo
        - Get me to run malicious code
        - Create a user
          - Get me to create the user
            - Threaten
            - Blackmail
            - Convince
          - Find a vulnerability in SSH
          - Bypass the firewall and find a vulnerability in some other app
      - Find a sudo vulnerability that doesn't require a user account?
  - Hack Linux itself
  - Update the machine with with malicious configs
    - Compromise the infra repo (AND)
    - Get me to update with the malicious configs

### Compromising the astrid user

Goal: gain access to astrid@banana
  - Determine astrid user password
  - Get me to execute malicious code
    - Compromise one of the apps I use
    - Get me to install the attacker's app
    - Compromise an existing app and get me to install it

## Extracting one of astrid's SSH keys

Goal: Extract astrid's SSH key
  - Steal SSH private keys to SSH in
    - Take from BANANA's disk
      - Decrypt /home
        - (ZFS volume attack tree)
        - Acquire /home's key
          - Read key from /
            - Decrypt / (ZFS volume attack tree)
    - Take from servers with unencrypted disks
  - Compromise astrid@banana user