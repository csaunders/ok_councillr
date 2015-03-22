# OKCouncillor

OKCouncillor is a data scraper, API, and civic engagement app. The scraper pulls data from the City of Toronto council meetings and parses it into a database, the API serves the data up as JSON, and the app allows people to discover how their councillor matches with their political leanings.

To Seed the database with both real and fake data, run `rake okc:fresh`. This will download the City Council Agendas from 2014 and seed the database with items from the third agenda.
