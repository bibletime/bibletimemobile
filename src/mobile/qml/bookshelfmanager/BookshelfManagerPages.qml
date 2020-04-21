import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.3

Item {
    id: shelfPages

    property alias index: pages.currentIndex
    property font font: Qt.font({ family: "Helvetica", pointSize: 10, weight: Font.Normal })

    signal finishPage
    signal beginPage
    signal normalPage
    signal installPage

    enum PageName {
        Task=0,
        Update=1,
        Updating=2,
        Libraries=3,
        Languages=4,
        Documents=5,
        Install=6,
        UpdatingDoc=7,
        RemovingDoc=8
    }

    function initialize() {
        setCurrentPage(0);
        updatePage.update = false;
    }

    function setCurrentPage(page) {
        if (page >= pages.count)
            return;
        if (page < 0)
            return;
        pages.currentIndex = page;
        setButtons();
    }

    function nextPage() {
        donePage();
        if (index === BookshelfManagerPages.PageName.Task) {
            if (taskPage.remove)
                index = BookshelfManagerPages.PageName.RemovingDoc
            else
                index = BookshelfManagerPages.PageName.Update;
        }
        else if (index === BookshelfManagerPages.PageName.Update) {
            if (updatePage.update)
                index = BookshelfManagerPages.PageName.Updating;
            else if (taskPage.update)
                index=BookshelfManagerPages.PageName.UpdatingDoc
            else
                index = BookshelfManagerPages.PageName.Libraries;
        }
        else if (index === BookshelfManagerPages.PageName.Updating) {
            if (taskPage.update)
                index = BookshelfManagerPages.PageName.UpdatingDoc;
            else
                index = BookshelfManagerPages.PageName.Libraries;
        }
        else if (index === BookshelfManagerPages.PageName.Libraries)
            index = BookshelfManagerPages.PageName.Languages;

        else if (index === BookshelfManagerPages.PageName.Languages)
            index = BookshelfManagerPages.PageName.Documents;
        setButtons();
        initPage();
    }

    function installButtonPressed() {
        index = BookshelfManagerPages.PageName.Install;
        initPage();
    }

    function prevPage() {
        if (index === BookshelfManagerPages.PageName.Documents)
            index = BookshelfManagerPages.PageName.Languages;
        else if (index === BookshelfManagerPages.PageName.Languages)
            index = BookshelfManagerPages.PageName.Libraries;
        else if (index === BookshelfManagerPages.PageName.Libraries)
            index = BookshelfManagerPages.PageName.Update;
        else if (index === BookshelfManagerPages.PageName.Updating)
            index = BookshelfManagerPages.PageName.Update;
        else if (index === BookshelfManagerPages.PageName.Update)
            index = BookshelfManagerPages.PageName.Task;
        else if (index === BookshelfManagerPages.PageName.UpdatingDoc)
            index = BookshelfManagerPages.PageName.Task;
        else if (index === BookshelfManagerPages.PageName.RemovingDoc)
            index = BookshelfManagerPages.PageName.Task;
        else if (index === BookshelfManagerPages.PageName.Install)
            index = BookshelfManagerPages.PageName.Documents;
        setButtons();
    }

    function setButtons() {
        if (index === 0)
            beginPage();
        else if (index === BookshelfManagerPages.PageName.Install ||
                 index === BookshelfManagerPages.PageName.UpdatingDoc ||
                 index === BookshelfManagerPages.PageName.RemovingDoc)
            finishPage();
        else if (index === BookshelfManagerPages.Documents)
            installPage();
        else
            normalPage();
    }

    function initPage() {
        if (pages.currentIndex === BookshelfManagerPages.PageName.Libraries) {
            libraryPage.initPage();
        }
        else if (pages.currentIndex === BookshelfManagerPages.PageName.Languages) {
            languagePage.initPage();
        }
        else if (pages.currentIndex === BookshelfManagerPages.PageName.Documents) {
            documentPage.initPage();
        }
        else if (pages.currentIndex === BookshelfManagerPages.PageName.Install) {
            installDocumentsPage.initPage();
        }
    }

    function donePage() {
        if (pages.currentIndex === BookshelfManagerPages.PageName.Libraries) {
            libraryPage.donePage();
        }
        else if (pages.currentIndex === BookshelfManagerPages.PageName.Languages) {
            languagePage.donePage();
        }
        else if (pages.currentIndex === BookshelfManagerPages.PageName.Documents) {
            documentPage.donePage();
        }
    }

    StackLayout {
        id: pages

        anchors.fill: parent
        currentIndex: 0
        z:2

        TaskPage {
            id: taskPage

            font: shelfPages.font
        }

        UpdateLibrariesPage {
            id: updatePage

            font: shelfPages.font
        }

        UpdatingLibrariesPage {
            font: shelfPages.font
        }

        ChooseLibraryPage {
            id: libraryPage

            font: shelfPages.font
        }

        ChooseLanguagePage {
            id: languagePage

            font: shelfPages.font
        }

        ChooseDocumentsPage {
            id: documentPage
            font: shelfPages.font
        }

        InstallPage {
            id: installDocumentsPage
            font: shelfPages.font
        }

        UpdatingDocumentsPage {
            font: shelfPages.font
        }

        RemoveDocumentsPage {
            font: shelfPages.font
        }
    }

    Rectangle {
        anchors.fill: parent
        color: Material.background
    }

}
