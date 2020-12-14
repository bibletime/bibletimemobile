import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.3

Item {
    id: bookshelfPages

    property alias index: pages.currentIndex
    property font font: Qt.font({ family: "Helvetica", pointSize: 10, weight: Font.Normal })

    enum PageName {
        Task=0,
        UpdateSourcesQuestion=1,
        UpdateSources=2,
        ChooseSources=3,
        ChooseLanguages=4,
        ChooseDocuments=5,
        InstallDocuments=6,
        UpdateDocuments=7,
        RemoveDocuments=8
    }

    function initialize() {
        pages.currentIndex = BookshelfManagerPages.PageName.Task
        initPage();
        updateSourcesQuestionPage.update = false;
        taskPage.install = true;
    }

    function nextPage() {
        donePage();
        if (taskPage.remove)
            nextRemovePage();
        else if (taskPage.update)
            nextUpdatePage();
        else
            nextInstallPage();
        initPage();
    }

    function nextInstallPage() {
        if (index === BookshelfManagerPages.PageName.Task) {
            index = BookshelfManagerPages.PageName.UpdateSourcesQuestion
        } else if (index === BookshelfManagerPages.PageName.UpdateSourcesQuestion) {
            if (updateSourcesQuestionPage.update)
                index = BookshelfManagerPages.PageName.UpdateSources;
            else
                index = BookshelfManagerPages.PageName.ChooseSources;
        } else if (index === BookshelfManagerPages.PageName.UpdateSources) {
            index = BookshelfManagerPages.PageName.ChooseSources;
        } else if (index === BookshelfManagerPages.PageName.ChooseSources) {
            index = BookshelfManagerPages.PageName.ChooseLanguages;
        } else if (index === BookshelfManagerPages.PageName.ChooseLanguages) {
            index = BookshelfManagerPages.PageName.ChooseDocuments;
        } else if (index === BookshelfManagerPages.PageName.ChooseDocuments)
            index = BookshelfManagerPages.PageName.InstallDocuments;
    }

    function nextUpdatePage() {
        if (index === BookshelfManagerPages.PageName.Task) {
            index = BookshelfManagerPages.PageName.UpdateSources;
        } else if (index === BookshelfManagerPages.PageName.UpdateSources) {
            index = BookshelfManagerPages.PageName.UpdateDocuments;
        } else if (index === BookshelfManagerPages.PageName.UpdateDocuments) {
        index = BookshelfManagerPages.PageName.InstallDocuments;
        }
    }

    function nextRemovePage() {
        if (index === BookshelfManagerPages.PageName.Task) {
            index = BookshelfManagerPages.PageName.RemoveDocuments
        }
    }

    function prevPage() {
        if (taskPage.remove)
            prevRemovePage();
        else if (taskPage.update)
            prevUpdatePage();
        else
            prevInstallPage();
        initPage();
    }

    function prevInstallPage() {
        if (index === BookshelfManagerPages.PageName.InstallDocuments)
            index = BookshelfManagerPages.PageName.ChooseDocuments;
        else if (index === BookshelfManagerPages.PageName.ChooseDocuments)
            index = BookshelfManagerPages.PageName.ChooseLanguages;
        else if (index === BookshelfManagerPages.PageName.ChooseLanguages)
            index = BookshelfManagerPages.PageName.ChooseSources;
        else if (index === BookshelfManagerPages.PageName.ChooseSources)
            index = BookshelfManagerPages.PageName.UpdateSourcesQuestion;
        else if (index === BookshelfManagerPages.PageName.UpdateSources)
            index = BookshelfManagerPages.PageName.UpdateSourcesQuestion;
        else if (index === BookshelfManagerPages.PageName.UpdateSourcesQuestion)
            index = BookshelfManagerPages.PageName.Task;
    }

    function prevUpdatePage() {
        if (index === BookshelfManagerPages.PageName.InstallDocuments)
            index = BookshelfManagerPages.PageName.Task;
        else if (index === BookshelfManagerPages.PageName.UpdateDocuments)
            index = BookshelfManagerPages.PageName.Task;
    }

    function prevRemovePage() {
        if (index === BookshelfManagerPages.PageName.RemoveDocuments)
            index = BookshelfManagerPages.PageName.Task;
    }

    function initPage() {
        var page = currentItem(pages.currentIndex);
        console.log(pages.currentIndex, page);
        page.initPage();
    }

    function donePage() {
        var page = currentItem(pages.currentIndex);
        page.donePage();
    }

    function currentItem(index) {
        if (index === BookshelfManagerPages.PageName.Task) {
            return taskPage;
        }
        else if (index === BookshelfManagerPages.PageName.UpdateSourcesQuestion) {
            return updateSourcesQuestionPage;
        }
        else if (index === BookshelfManagerPages.PageName.UpdateSources) {
            console.log("xxx")
            return updateSourcesPage;
        }
        else if (index === BookshelfManagerPages.PageName.ChooseSources) {
            return chooseSourcesPage;
        }
        else if (index === BookshelfManagerPages.PageName.ChooseLanguages) {
            return chooseLanguagesPage;
        }
        else if (index === BookshelfManagerPages.PageName.ChooseDocuments) {
            return chooseDocumentPage;
        }
        else if (index === BookshelfManagerPages.PageName.InstallDocuments) {
            return installDocumentsPage;
        }
        else if (index === BookshelfManagerPages.PageName.UpdateDocuments) {
            return updateDocumentsPage;
        }
        else if (index === BookshelfManagerPages.PageName.RemoveDocuments) {
            return removeDocumentsPage;
        }
        console.log("currentItem error");
    }

    StackLayout {
        id: pages

        anchors.fill: parent
        currentIndex: 0
        z:2

        TaskPage {
            id: taskPage

            font: bookshelfPages.font
        }

        UpdateSourcesQuestionPage {
            id: updateSourcesQuestionPage

            font: bookshelfPages.font
        }

        UpdateSourcesPage {
            id: updateSourcesPage

            font: bookshelfPages.font
        }

        ChooseSourcesPage {
            id: chooseSourcesPage

            font: bookshelfPages.font
        }

        ChooseLanguagesPage {
            id: chooseLanguagesPage

            font: bookshelfPages.font
        }

        ChooseDocumentsPage {
            id: chooseDocumentPage
            font: bookshelfPages.font
        }

        InstallDocumentsPage {
            id: installDocumentsPage
            font: bookshelfPages.font
        }

        UpdateDocumentsPage {
            id: updateDocumentsPage

            font: bookshelfPages.font
        }

        RemoveDocumentsPage {
            id: removeDocumentsPage

            font: bookshelfPages.font
        }
    }

    Rectangle {
        anchors.fill: parent
        color: Material.background
    }
}
