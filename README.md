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

Supported Types are `Ios`, `Vrp, `Seos`, and `Timos`.

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

