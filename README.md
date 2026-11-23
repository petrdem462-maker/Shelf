#Shelf
Shelf is an app for creating your own digit library, where you can search for books, save them, and keep track of your stats.
<p>
  <img src="docs/Screenshots/default_search.png" width="200" alt="Search start screen">
  <img src="docs/Screenshots/active_search.png" width="200" alt="Search results">
  <img src="docs/Screenshots/library.png" width="200" alt="Library">
  <img src="docs/Screenshots/stats.png" width="200" alt="Stats">
</p>
## Features

- **Search** books by title or author, with search-as-you-type (debounced, cancels outdated requests)
- **Book details**: cover, description, subjects and rating, loaded in parallel
- **Library**: save books as *Want to read*, *Reading* or *Finished*; stored locally, works offline
- **Reading log**: record pages read; progress bar per book; a book is finished automatically at its last page
- **Stats**: pages this month, reading days, books finished this year, top books and a 30-day chart
- **Ratings refresh**: pull to refresh ratings for all library books at once
- **Image cache**: covers are downloaded once and reused