# SWAPI Test Task
> I wrote this app back in 2019, I've did some updates to code in Novermber 2022.
>
> Unfortulately swapi.co is not maintained anymore, app is using swapi.dev now.

### Application that interacts with SWAPI.com API

- Ability to search for a character of SW universe
- Ability to show detail screen with additional info
- Keeps information about already searched characters and shows it without network

### Implementation

- MainViewController is a TableView filled with recently searched characters that are stored in CoreData.
- SearchViewController shows search results. Custom searchBar (oh god, 2019). Previous API request gets canceled if new symbol is added.
- DetailViewController shows character information ether from CoreData or it uses URLs from search response model and downloads details about each character property then saves to CoreData.

![Main](/Screenshots/Main.png)
![](/Screenshots/Detail.png)
