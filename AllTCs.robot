*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${APPLICATION_URL}    https://top-movies-qhyuvdwmzt.now.sh/
${BROWSER}            chrome
${SHAWSHANK_TITLE}    The Shawshank Redemption
${SHAWSHANK_RELEASE_DATE}    1994-09-23
${STAR_TREK_SEARCH_TERM}    Star Trek
${STAR_TREK_FIRST_CONTACT_TITLE}    Star Trek: First Contact
${FAVORITE_MOVIE_TITLE}    Pulp Fiction
${PULP_FICTION_RELEASE_DATE}    1994-10-14
${PULP_FICTION_POPULARITY}    109.28
${PULP_FICTION_VOTE_AVERAGE}    8.5
${PULP_FICTION_VOTE_COUNT}    25489

*** Keywords ***
Open Browser To Application
    Open Browser    ${APPLICATION_URL}    ${BROWSER}
    Maximize Browser Window

Verify Movie Tiles Displayed
    Wait Until Element Is Visible    class=movie-tile
    ${movie_tiles}    Get Matching Xpath Count    //div[@class='movie-tile']
    Should Be True    ${movie_tiles} > 0    At least one movie tile should be displayed.

Open Movie Details
    [Arguments]    ${movie_title}
    Click Element    xpath=//h2[text()='${movie_title}']/ancestor::div[@class='movie-tile']

Verify Release Date
    [Arguments]    ${expected_date}
    Wait Until Element Is Visible    xpath=//p[contains(text(), 'Released on')]/span
    ${actual_date}    Get Text    xpath=//p[contains(text(), 'Released on')]/span
    Should Be Equal    ${actual_date}    ${expected_date}

Search For Movie
    [Arguments]    ${search_term}
    Wait Until Element Is Visible    id=search-input
    Input Text    id=search-input    ${search_term}
    Click Element    id=search-button

Verify Movie Is Visible
    [Arguments]    ${movie_title}
    Wait Until Element Is Visible    xpath=//h2[text()='${movie_title}']

Verify Movie Is Not Visible
    [Arguments]    ${movie_title}
    Wait Until Element Is Not Visible    xpath=//h2[text()='${movie_title}']

Verify Movie Details
    [Arguments]    ${release_date}    ${popularity}    ${vote_average}    ${vote_count}
    Wait Until Element Is Visible    xpath=//p[contains(text(), 'Released on')]/span
    ${actual_release_date}    Get Text    xpath=//p[contains(text(), 'Released on')]/span
    Should Be Equal    ${actual_release_date}    ${release_date}

    Wait Until Element Is Visible    xpath=//p[contains(text(), 'Popularity')]/span
    ${actual_popularity_str}    Get Text    xpath=//p[contains(text(), 'Popularity')]/span
    ${actual_popularity}    Convert To Number    ${actual_popularity_str}
    Should Be True    ${actual_popularity} >= ${popularity} - 0.1 and ${actual_popularity} <= ${popularity} + 0.1    Popularity should be approximately ${popularity}, but was ${actual_popularity}.

    Wait Until Element Is Visible    xpath=//p[contains(text(), 'Vote Average')]/span
    ${actual_vote_average_str}    Get Text    xpath=//p[contains(text(), 'Vote Average')]/span
    ${actual_vote_average}    Convert To Number    ${actual_vote_average_str}
    Should Be True    ${actual_vote_average} >= ${vote_average} - 0.1 and ${actual_vote_average} <= ${vote_average} + 0.1    Vote Average should be approximately ${vote_average}, but was ${actual_vote_average}.

    Wait Until Element Is Visible    xpath=//p[contains(text(), 'Vote Count')]/span
    ${actual_vote_count_str}    Get Text    xpath=//p[contains(text(), 'Vote Count')]/span
    ${actual_vote_count}    Convert To Number    ${actual_vote_count_str}
    Should Be True    ${actual_vote_count} >= ${vote_count} - 100 and ${actual_vote_count} <= ${vote_count} + 100    Vote Count should be approximately ${vote_count}, but was ${actual_vote_count}.

Close Browser Application
    Close Browser

*** Test Cases ***
Verify Movie List Display
    Open Browser To Application
    Verify Movie Tiles Displayed
    Close Browser Application

Verify Shawshank Redemption Release Date
    Open Browser To Application
    Open Movie Details    ${SHAWSHANK_TITLE}
    Verify Release Date    ${SHAWSHANK_RELEASE_DATE}
    Close Browser Application

Verify Search Functionality
    Open Browser To Application
    Search For Movie    ${STAR_TREK_SEARCH_TERM}
    Verify Movie Is Visible    ${STAR_TREK_FIRST_CONTACT_TITLE}
    Verify Movie Is Not Visible    ${SHAWSHANK_TITLE}
    Close Browser Application

Verify Favorite Movie Details
    Open Browser To Application
    Open Movie Details    ${FAVORITE_MOVIE_TITLE}
    Verify Movie Details    ${PULP_FICTION_RELEASE_DATE}    ${PULP_FICTION_POPULARITY}    ${PULP_FICTION_VOTE_AVERAGE}    ${PULP_FICTION_VOTE_COUNT}
    Close Browser Application