# Ghost Runner on iOS :ghost:

> Developed by Team DZKN:

> Dylan Long  
https://www.linkedin.com/in/dylanalong1/  
https://github.com/dylanalong

> Ziyu Wang

> Kamyab Ayanifard

> Nikita Andrikanis

**NOTE:** Milestone 1 link is found at the bottom of this README!

### Our proposal:

***Ghost Runner***: the anonymous running platform with a competitive edge. Similar to racing games, previously recorded runs will be represented as “ghosts”, or colored dots on the map, as if running beside you. These recorded runs may come from both the user themself and anonymously from the user base. The user would be able to select a “target pace” that would be displayed in a time-interval UI element. This would display the user’s time split for each section of their run, pairing the number with a color feedback (the overall accent color of the UI would shift between red-blue-green; below pace, on pace, and above pace, respectively). Thus, this app would serve the purpose of a highly customizable, self-paced personal trainer via the time-interval UI, as well as bringing the competitive excitement of racing against other “ghosts” on the map.

The core of the app lies in our algorithm, which would take the geo-data and time-stamps and compute a “run”, which would be split up into adjustable sectors. The user would receive audio-visual feedback on their performance relative to these sectors. This algorithm would ideally be able to tackle short runs, long runs, and runs through difficult-to-predict terrain, providing a consistent user experience for all running goals and fitness levels.

### Sprint Chart (Trello):
[Link to Trello Board](https://trello.com/b/EvIk6hce/dzkn-ghost-runner)

Week 0 + 1 Brief Assignments (these are found in more detail in the meeting notes and Trello):
- Backend (Kami): set up backend, determine data type and their formats
- Algorithm (Dylan): algorithm prototypes, user cases, run customization
- Main UI (Nikita): design main UI, MapKit implementation, time-sector UI element, create theme and graphics
- Login/Auth (Ziyu): login framework, login UI

Week 2 Brief Assignments (see 18 February's meeting notes for details/elaboration):
- Backend (Kami): develop user login data pipeline; develop cloud function regarding best detection; work with Dylan on algorithm
- Algorithm (Dylan): continue developing the run algorithm
- Main UI (Nikita): fully implement main UI and test the full data pipeline
- Login/Auth (Ziyu): implement user sign-in and sign-up in the login UI


### Meeting Notes:

11 February 2021 - [Sprint Planning 1 and Proposal](https://docs.google.com/document/d/1Y4POqneNCZ1JXG9e6VGOsLXFdwB2L2I7I2TDs0K9TpU/edit?usp=sharing)

18 February 2021 - [Sprint Planning 2](https://docs.google.com/document/d/1WIuyM43pmhlOwvQq3lfGjFDhGgT85jWmO40kayEHhEU/edit?usp=sharing)

### Milestones:

22 February 2021 - [Milestone 1](https://docs.google.com/document/d/1cL5qjSXlPTK8lDtkn_iZbdCze0-BJGtdw--Mh1lu0pw/edit?usp=sharing)
