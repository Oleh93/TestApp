# TestApp

Simple test application

## Description

1. The first screen contains two input fields and one button.
    1. The input fields require the user to input two different numbers, lower bound and upper bound.
    2. After inputting the numbers, the user can press the button.
2. Pressing the button presents the user in another screen the result of
comments from an API call to https://jsonplaceholder.typicode.com
3. The comments that would be displayed on the second screen would be sorted by id
(ascending order). And only the comments with ids between the lower bound and the
upper bound are displayed.
4. The app uses pagination logic. It loads next 10 comments each time user scrolls till the end of current 10 comments.

## Screenshots

<p align="center" width="100%">
    <img width="30%" src="https://drive.google.com/uc?export=view&id=1iFkdi14SgyiiDFtKt4L-AItMj7fvBrpL">
    <img width="30%" src="https://drive.google.com/uc?export=view&id=1xWYRWl3E7oXO1AoTWcUWim-GYE0-8li1">
</p>

## Tech

**Architecture:** Protocols based MVVM  
**API:** https://jsonplaceholder.typicode.com  
**External libraries:** https://github.com/hackiftekhar/IQKeyboardManager  
**Features:** handwritten pagination, text fields validation, native well-designed UX/UI  

## Installation

Open terminal in root folder

```
open TestTask.xcodeproj
```

hit ```Command + R```
