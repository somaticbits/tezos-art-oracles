<div id="top"></div>
<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Don't forget to give the project a star!
*** Thanks again! Now go create something AMAZING! :D
-->



<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]



<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/somaticbits/oracle">
    <img src="images/logo.png" alt="Logo" width="80" height="80">
  </a>

<h3 align="center">Tezos Blockchain Oracle for the Arts</h3>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

[![Product Name Screen Shot][product-screenshot]](https://example.com)

Here's a blank template to get started: To avoid retyping too much info. Do a search and replace with your text editor for the following: `somaticbits`, `oracle`, `somaticbits`, `david-pettersson`, `somaticbits`, `david`, `Tezos Blockchain Oracle for the Arts`, `project_description`

<p align="right">(<a href="#top">back to top</a>)</p>



### Built With

* [LIGO](https://ligolang.org/)
* [Flextesa](https://tezos.gitlab.io/flextesa/)
* [Docker](https://www.docker.com/)
* [Tezos-client](https://assets.tqtezos.com/docs/setup/1-tezos-client/)

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- GETTING STARTED -->
## Getting Started

The repository is composed of four different smart contracts:
* oracle_xxx: these are the various smart contracts serving as oracles. Their main difference lies in the storage structure
* user: this is an example smart contract that can fetch data from the oracles, it is using views to avoid data costs.

Each oracle has different scripts:
* ``compile.sh``: this compiles the smart contract into Michelson, ready to be deployed
* ``originate.sh``: this compiles and deploys the contract on the hangzhou testnet
* ``originate_sandbox.sh``:  this compiles and deploys the contract onto the flextesa sandbox
* ``run_tests.sh``: this runs the unit tests present in ``partials/test.mligo``

### Prerequisites

First, get the Tezos development stack for LIGO running (Linux). This will be necessary for further development and compilation / deployement of the smart contracts:
* LIGO - detailed instructions can be found [here](https://ligolang.org/docs/intro/installation)
  ```sh
  wget https://gitlab.com/ligolang/ligo/-/jobs/2481359029/artifacts/raw/ligo
  chmod +x ./ligo
  ```
* Tezos-client
  ```sh
  wget https://github.com/serokell/tezos-packaging/releases/latest/download/tezos-client
  chmod +x tezos-client
  mkdir -p $HOME/.local/bin
  mv tezos-client $HOME/.local/bin
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> $HOME/.bashrc
  source $HOME/.bashrc
  ```
* Each Tezos account needs to be registered by the Tezos-client in order to be able to deploy (for sandbox, check below):
  ```sh
  tezos-client import secret key <account_alias> <secret_key>
  ```

* (optional) Run the sandbox
  ```sh
  docker run --rm --name objkt-sandbox --detach -p 20000:20000 -e block_time=3 oxheadalpha/flextesa:latest hangzbox start
  ```
* (optional) Sandbox accounts can be found like this:
  ```sh
  docker run --rm oxheadalpha/flextesa:latest hangzbox info
  ```


### Installation (oracles on testnet)

1. Clone the repo
   ```sh
   git clone https://github.com/somaticbits/oracle.git
   ```
2. Change the admin address inside each storage (can be found in ``oracle_xxx/contracts/init_main_storage.mligo``) to the address deploying the contract.
  ```ligoLANG
  ({sensor_ledger=(Big_map.literal[(0n,0n),0n]);n_data_ids=(Map.literal[(0n,0n)]);admin=("<admin_address>":address)})
  ```
3. Replace the account deploying the contract to the account registered by the tezos-client in the `oracle_xxx/originate.sh` script:
  ```sh
  tezos-client -E https://hangzhounet.smartpy.io originate contract main transferring 1 from <account_alias> running ./contracts/main.tz --init "`cat ./contracts/main_storage.tz`" --burn-cap 2 --force
  ```
4. Deploy the contract on the hangzhou testnet:
  ```sh
  ./originate.sh
  ```

### Installation (oracles on Flextesa sandbox)
1. Clone the repo
   ```sh
   git clone https://github.com/somaticbits/oracle.git
   ```
2. Change the admin address inside each storage (can be found in ``oracle_xxx/contracts/init_main_storage.mligo``) to the addresses present on the sandbox.
  ```ligoLANG
  ({sensor_ledger=(Big_map.literal[(0n,0n),0n]);n_data_ids=(Map.literal[(0n,0n)]);admin=("<admin_address>":address)})
  ```
3. Replace the account deploying the contract to the account registered by the tezos-client in the `oracle_xxx/originate_sandbox.sh` script:
  ```sh
  tezos-client -E http://localhost:20000 originate contract main transferring 1 from <account_alias> running ./contracts/main.tz --init "`cat ./contracts/main_storage.tz`" --burn-cap 2 --force
  ```
4. Deploy the contract on the sandbox:
  ```sh
  ./originate_sandbox.sh
  ```


<p align="right">(<a href="#top">back to top</a>)</p>



<!-- USAGE EXAMPLES -->
## Usage

Use this space to show useful examples of how a project can be used. Additional screenshots, code examples and demos work well in this space. You may also link to more resources.

_For more examples, please refer to the [Documentation](https://example.com)_

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- ROADMAP -->
## Roadmap

- [ ] Feature 1
- [ ] Feature 2
- [ ] Feature 3
    - [ ] Nested Feature

See the [open issues](https://github.com/somaticbits/oracle/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

Your Name - [@somaticbits](https://twitter.com/somaticbits) - david@somaticbits.com

Project Link: [https://github.com/somaticbits/oracle](https://github.com/somaticbits/oracle)

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

* []()
* []()
* []()

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/somaticbits/oracle.svg?style=for-the-badge
[contributors-url]: https://github.com/somaticbits/oracle/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/somaticbits/oracle.svg?style=for-the-badge
[forks-url]: https://github.com/somaticbits/oracle/network/members
[stars-shield]: https://img.shields.io/github/stars/somaticbits/oracle.svg?style=for-the-badge
[stars-url]: https://github.com/somaticbits/oracle/stargazers
[issues-shield]: https://img.shields.io/github/issues/somaticbits/oracle.svg?style=for-the-badge
[issues-url]: https://github.com/somaticbits/oracle/issues
[license-shield]: https://img.shields.io/github/license/somaticbits/oracle.svg?style=for-the-badge
[license-url]: https://github.com/somaticbits/oracle/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/david-pettersson
[product-screenshot]: images/screenshot.png
