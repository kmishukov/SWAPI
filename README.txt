SWAPI.COM Application Test Task

Главный экран MainTableViewConrtoller показывает список «уже просмотренных» персонажей, который наполняется из Core Data. Детальная информация о персонажах из данного списка доступна без интернета.

RightBarButtonItem -> переход на SearchViewController. Сделал кастомный, удовлетворяющий цветовую схему приложения, SearchBar (oh god why). Запрос к серверу (func updateSearchResults(text:)) осуществляется по мере набора символов в строку поиска (searchBar.textField) с использованием функции NSObject.cancelPreviousPerformRequests 

DetailViewConrtoller - экран детальной информации по персонажу, переход на него осуществляется через ячейку любой из таблиц (mainTableViewController или SearchViewController):
а) При переходе с главной страницы в prepareForSegue будет передан тип Person.
Б) При переходе с экрана поиска будет передан тип jsonPersonSearchObject.Person. Запросы по детальной информации о персонаже (vehicles, homeworld и др) отправляются асинхронно функцией parseJsonPersonObject после перехода на экран детальной информации. После получения всех детальных данных строится самый полный объект Person и в случае если ранее он не был добавлен в Core Data - он будет сохранен сохраняется.
