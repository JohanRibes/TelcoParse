# TelcoParse
A "universal" parser script to help telco technicians to read configuration files and manipulate them.

## To do what
* Simple ruby scripts to extract vlan, interfaces or banners from telco equipments.
* Straight calls to libraries of functions to extract basic informations.

## Compatible device configurations
1. Cisco: IOS, IOS-XE, IOS-XR, Catos (some adjustments to come).
2. Huawei: VRP.
3. Redback: SeOS
4. Alcatel-Lucent: TimOS.

## Library
### What's extracted
1. `[Type]::Get.rancid(eqt)` extracts all lines that are commented in rancid's fashion.
2. `[Type]::Get.section(eqt)` extracts each block detected as a section from the mail file.
3. `Seos::Get.context(eqt)` (redback only) extracts context related informations.
4. `[Type]::Get.banners(eqt)` extratcs each banners (motd, exec, login).
5. `[Type]::Get.domain_name(eqt)` extracts domain name.
6. `[Type]::Get.hostname(eqt)`extracts hostname.
7. `[Type]::Get.interfaces_desc(eqt)` extracts interfaces names, descrptions and returns a simple 2-dimensions array (including Vlans, Bundles, etc).

Supported Types are `Ios`, `Vrp`, `Seos`, and `Timos`.

### Example

``` ruby
# Calls
require_relative 'lib/parse.rb'
require_relative 'lib/ios.rb'
require_relative 'lib/vrp.rb'
require_relative 'lib/seos.rb'
require_relative 'lib/timos.rb'

########
MY CONF import where my file will be stored in `eqt` array.
########

puts Ios::Get.hostname(eqt)
puts IOS::Get.domain_name(eqt)

```


## CLI
### Usage

```bash
# ./TelcoParse.rb --help

Usage: TelcoParse file_to_parse [options]
    -t, --type [STRING]              A single string describing the configuration type (ex: "Cisco IOS")
    -h, --help                       Show this message
```

Supported types are `ios`, `vrp`, `seos` and `timos`.

## Example
You have one sample configuration file to play with in the `/conf` directory. One for each type.

```bash
./TelcoParse.rb conf/IOS_example.net -t ios
                                                  **************************************************
                                                  **************************************************
                                                           **    MYROUTER.groland.net    **
                                                  **************************************************
                                                  **************************************************
                                                             Configuration has 294 lines.


Name     : MY_ROUTER
STATE    : CA
Address  : Venice Beach
Room     : Outside!
Type     : Cisco 3550-12G


14 Interfaces:
[X] GigabitEthernet0/1                                                                                                                              to WAN
[ ] GigabitEthernet0/2
[ ] GigabitEthernet0/3                                                                                                                        To_first_cpe
[ ] GigabitEthernet0/4
[X] GigabitEthernet0/5                                                                                                                           to_radius
[ ] GigabitEthernet0/6
[ ] GigabitEthernet0/7
[X] GigabitEthernet0/8                                                                                                                  to-second_customer
[X] GigabitEthernet0/9                                                                                                                          to_tactacs
[ ] GigabitEthernet0/10
[X] GigabitEthernet0/11                                                                                                                        static_bckp
[X] GigabitEthernet0/12                                                                                                                      to_customer_3
[ ] Vlan1
[X] Vlan2                                                                                                                                   best_vlan_EVER
                                                                                                                                              Customers: 2
```

## Cherry on the top
The `lib/parse.rb` file contains a **Detect** module in which you can specify a certain string that can be.. detected.
The purpose of this functionnality is to locate an interfaces that I want to care more (customers CPE in my case).
You can change the strings to suit your needs directly in the file.
