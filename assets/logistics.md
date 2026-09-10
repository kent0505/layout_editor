# State abbreviations

|State|State|
|---|---|
|**AL** - Alabama       |**MT** - Montana  
|**AK** - Alaska        |**NE** - Nebraska 
|**AZ** - Arizona       |**NV** - Nevada  
|**AR** - Arkansas      |**NH** - New Hampshire 
|**CA** - California    |**NJ** - New Jersey  
|**CO** - Colorado      |**NM** - New Mexico  
|**CT** - Connecticut   |**NY** - New York  
|**DE** - Delaware      |**NC** - North Carolina  
|**FL** - Florida       |**ND** - North Dokota  
|**GA** - Georgia       |**OH** - Ohio  
|**HI** - Hawaii        |**OK** - Oklahoma  
|**ID** - Idaho         |**OR** - Oregon  
|**IL** - Illinois      |**PA** - Pennsylvania  
|**IN** - Indiana       |**RI** - Rhode Island  
|**IA** - Iowa          |**SC** - South Carolina  
|**KS** - Kansas        |**SD** - South Dakota  
|**KY** - Kentucky      |**TN** - Tennessee  
|**LA** - Louisiana     |**TX** - Texas  
|**ME** - Maine         |**UT** - Utah  
|**MD** - Maryland      |**VT** - Vermont  
|**MA** - Massachesetts |**VA** - Virginia  
|**MI** - Michigan      |**WA** - Washington 
|**MN** - Minnesota     |**WV** - West Virginia  
|**MS** - Mississipi    |**WI** - Wisconsin  
|**MO** - Missouri      |**WY** - Wyoming  

# Time zones

- Pacific Time (12:30) (PT)
- Mountain Time (13:30) (MT)
- Central Time (14:30) (CT)
- Eastern Time (15:30) (ET)

Разница в 1 час.  
В зависимости от города у штатов **KY**, **TN**, **IN** время разное.  
**AZ** с март-ноябрь Pacific, декабрь-февраль Mountain.  

# Carrier company departments
- driver
- dispatch
- update
- safety
- fleet 
- accounting 
- recruiting 
- ELD monitoring

# Logistics process

1) offering and booking the load (dispatcher)
2) rolling/driving to pickup/shipper
3) arrival to shipper, **PU** number, loading
4) loaded, checking **BOL**, sending it to broker
5) rolling to the receiver/delivery, transit updates
6) arrival to receiver, delivery number, unloading
7) empty, checking **POD**, sending it to broker

# ELD

Electronic logging device  
Устройство которое подключают к грузовику

|Title|Duration|Rest|
|---|---|---|
|**cycle** |70h| rest 34h
|**shift** |14h| rest 10h
|**drive** |11h| rest 30m after 8h
|**break** |8h |

Status
1. **off duty** (shift ended / truck is shut down)
2. **on duty** (shift started)
3. **driving** (more than 5mph speed)
4. **sleeper berth** (sleeping or resting)
5. **personal conveyance** (going home or personal uses)
6. **yard move**
7. **PTI** (pre trip inspection 15m)

# Truck structure

Bobtail - truck without trailer

Truck:
- fifth wheel (крепление к трейлеру)
- head lights (передние фары)
- rear lights (задние фары)
- fuel tank (бак)
- steer tires (передние колеса)
- drive tires (задние колеса)
  - driver side (левый)
    - front outside (передний внешний)
    - front inside (передний внутренний)
    - rear outside (задний внешний)
    - rear inside (задний внутренний)
  - passenger side (правый)
    - front outside (передний внешний)
    - front inside (передний внутренний)
    - rear outside (задний внешний)
    - rear inside (задний внутренний)

Trailer:
- king pin (крепление к траку)
- dry van - сухая коробка  
- e-track - место крепления ремней внутри трейлера (vertical/horizontal)  
- strap - ремень для крепления груза (driver)
- load bar - железный крепеж груза (driver)  
- block and brace - крепление груза гвоздями и досками (shipper)  
- air bags - крепление груза воздушными подушками (shipper)  

# Issues

### Rolling/driving to pickup/shipper & rolling to the receiver/delivery, transit updates

- Truck issue/break down
    - ask driver if he can fix it and how long it will take  
    - ask help from **fleet** department
    - update broker immediately
- Traffic jam
    - update broker (location, **ETA**, proof with picture)
- Delivery address changed during transit
    - inform the driver
    - if difference is big, request compensation for extra miles and request revised **RC**

### Arrival to shipper, PU number, loading

- Shipper is closed
    - find out working hours and come back once open
    - ask the broker when we can pick up (stay on the load or cancel)
- No or cant find **PU** number
    - check the **RC**
    - check the email chain
    - ask the driver to check tracking app (Macropoint, Trucker tools, 4 kites)
    - ask broker
- Not loading/loading slowly
    - ask driver for reason
    - ask/push the broker to reach out to shipper
    - reach out to shipper
    - request **detention** (after 2h) / **layover** (more than 8h)  
- Load is not available/different carrier picked up
    - update broker
    - ask broker for different load (dispatch's job)
    - if it is confirmed, request **TONU**

### Loaded, checking BOL, sending it to broker

- Overweight - shipper loaded more than agreed weight
    - check weight on **BOL** and ask driver to request rework from shipper (or ask broker)
    - after that ask driver to scale the load 
    - request compensation for overweight
- **BOL** not provided by shipper
    - ask driver to check with shipping office/guard shack
    - inform the broker and request **e-BOL** and send to driver
- **BOL** details are not matching **RC**
    - inform the broker and request GTG (good to go)
    - ask driver to double check with shipper
- Shipper did not provide a seal
    - inform broker and request GTG
    - ask driver to put his own seal and write its number on **BOL**

### Arrival to receiver, delivery number, unloading

- Receiver is closed
    - find out working hours and come back once open
    - ask the broker when we can deliver
- No or cant find **DEL** number
    - check the rate con
    - check the email chain
    - ask the driver to check tracking app (Macropoint, Trucker tools, 4 kites)
    - ask broker
- Not unloading/unloading slowly
    - ask driver for reason
    - ask/push the broker to reach out to receiver
    - reach out to receiver
    - request **Detention** (after 2h) / **Layover** (more than 8h)
- Full load rejection
    - ask receiver for reason and proof, mark rejection on **BOL** and send it to broker
    - broker will provide different warehouse to deliver near receiver

### Empty, checking POD (proof of delivery), sending it to broker

- Partial load rejection
    - ask receiver for reason and proof, mark rejection on **BOL** and send it to broker
    - donate & dispose - ask broker if we can utilize or give away or keep it 
- No signature or stamp
    - ask driver to go to shipping office or guard shack and get signature
    - or ask the broker for **POD** GTG without signatures

# Terms

### MC number
- motor carrier number
- уникальный номер логистической компании

### DOT number
- department of transportation number
- второй уникальный номер логистической компании

### GTG
- good to go
- брокер говорит, можно ехать

### RC
- rate confirmation
- appointment - именно шу вохт бориш кере
- FCFS - чем раньше тем лучше
- 24/7 - в любое время можно подъежать

### PU
- puck up 
- забор/загрузка груза

### DEL
- delivery 
- доставка

### BOL / e-BOL
- bill of lading
- документ загрузки груза
- shipper дает водиле
- если shipper не дал, то брокер скидывает e-BOL
- водила должен распечатать

### POD
- proof of delivery 
- подтверждение доставки
- должен быть подпись и печать

### ETA
- estimated time of arrival
- приблизительное время прибытия к месту назначение (место загрузки/выгрузки)

### Dead head
- 100mi normal
- can be any distance

### FTL / LTL
- full truck load (полный трейлер)
- less than truckload (часть трейлера)

### Detention - задержка
- money compensation for waiting  
- can request after 2h  
- standart rate: $25/h (solo) $50/h (team)  
- maximum $150 (solo) $250 (team)  
- recieved via revised **RC**  
- requirements:
    - driver cant be late
    - must write check in & check out times on the **BOL**
    - broker must be informed

### Layover - задержка 

- standart compensation for daily waiting  
- standart rate: $150 (solo) $250 (team)  
- requirements:
    - driver cant be late
    - must write check in & check out times on the **BOL**
    - broker must be informed

### TONU - truck ordered, not used

- standart compensation for empty miles
- standart rate: $150
- recieved via revised **RC**  
- requirements:
    - driver cant be late

### Lumper fee - payment for restacking & unloading service

- happens at receivers usually called by the receiver  
- broker must pay or we can pay and broker must reimburse  
- paid online via link  
- receipt must be send to the broker  
- payment methods:
    - EFS check
    - comcheck
    - T check
    - Credit card
    - Cash
