#Использовать asserts
#Использовать "../src"

Функция ПолучитьСписокТестов(Тестирование) Экспорт
    
    Список = Новый Массив;
    Список.Добавить("Тест_ДолженПроверитьЧтоПараметрыКомСтрокиПолученияВерсииРазобраны");
    Список.Добавить("Тест_ДолженПроверитьЧтоВерсияПолученаИзХранилища");
    Список.Добавить("Тест_ДолженПроверитьЧтоСозданыФайлыКонфигурацииПоставщика");
    Список.Добавить("Тест_ДолженПроверитьЧтоСозданДистрибутив");
    Список.Добавить("Тест_ДолженПроверитьЧтоСозданАрхивДистрибутива");
    
    Возврат Список;
    
КонецФункции

Процедура ПослеЗапускаТеста() Экспорт
    ВременныеФайлы.Удалить();
КонецПроцедуры

Процедура Тест_ДолженПроверитьЧтоПараметрыКомСтрокиПолученияВерсииРазобраны() Экспорт
    
    ПараметрыКомСтроки = Новый Соответствие;
    ПараметрыКомСтроки["АдресХранилища"] = "/some/path/storage";
    ПараметрыКомСтроки["-storage-user"] = "Администратор";
    ПараметрыКомСтроки["-storage-pwd"]  = "123";
    ПараметрыКомСтроки["-storage-v"]    = "4";
    
    Команда = Новый КомандаВыгрузитьИзХранилища;
    
    Параметры = Команда.РазобратьПараметры(ПараметрыКомСтроки);
    
    Ожидаем.Что(Параметры.АдресХранилища).Равно("/some/path/storage");
    Ожидаем.Что(Параметры.ПользовательХранилища).Равно("Администратор");
    Ожидаем.Что(Параметры.ПарольХранилища).Равно("123");
    Ожидаем.Что(Параметры.ВерсияХранилища).Равно("4");
    
КонецПроцедуры

Процедура Тест_ДолженПроверитьЧтоВерсияПолученаИзХранилища() Экспорт
    
    Команда = Новый КомандаВыгрузитьИзХранилища();
    
    ВремКаталогХранилища = СоздатьВременноеТестовоеХранилище();
    ВремФайлКонфигурации = ПолучитьИмяВременногоФайла("cf");
    Попытка
        Команда.ВыгрузитьВерсиюИзХранилища(ВремКаталогХранилища, 2, ВремФайлКонфигурации, "Администратор");
        ФайлТест = Новый Файл(ВремФайлКонфигурации);
        Ожидаем.Что(ФайлТест.Существует(), "файл конфигурации должен существовать"); 
    Исключение
        УдалитьФайлы(ВремКаталогХранилища);
        УдалитьФайлы(ВремФайлКонфигурации);
        ВызватьИсключение;
    КонецПопытки;
    
    УдалитьФайлы(ВремКаталогХранилища);
    УдалитьФайлы(ВремФайлКонфигурации);
    
КонецПроцедуры // Тест_ДолженПроверитьЧтоВерсияПолученаИзХранилища()

Функция СоздатьВременноеТестовоеХранилище() Экспорт
    ФайлХранилища = ТекущийСценарий().Каталог + "/fixtures/storage.1CD";
    ВремКаталогХранилища = ВременныеФайлы.СоздатьКаталог();
    СоздатьКаталог(ВремКаталогХранилища);
    КопироватьФайл(ФайлХранилища, ВремКаталогХранилища + "/1cv8ddb.1CD");
    
    Возврат ВремКаталогХранилища;
КонецФункции

Процедура Тест_ДолженПроверитьЧтоСозданыФайлыКонфигурацииПоставщика() Экспорт
    
    ВременноеХранилище = СоздатьВременноеТестовоеХранилище();
    КаталогСборки = ВременныеФайлы.СоздатьКаталог();
    Параметры = Новый Структура;
    Параметры.Вставить("АдресХранилища", ВременноеХранилище);
    Параметры.Вставить("КаталогСборки", КаталогСборки);
    Параметры.Вставить("ПользовательХранилища","Администратор");
    Параметры.Вставить("ПарольХранилища", "");
    Параметры.Вставить("ВерсияХранилища", "18");
    Параметры.Вставить("КаталогВерсий", ТекущийКаталог()+"__-__");
    Параметры.Вставить("ПредыдущиеВерсии", Новый Массив);
    
    Команда = Новый КомандаВыгрузитьИзХранилища;
    УправлениеКонфигуратором = Новый УправлениеКонфигуратором;
    УправлениеКонфигуратором.КаталогСборки(КаталогСборки);
    
    ВерсияИзХранилища = ПолучитьИмяВременногоФайла("cf");
    Команда.ВыгрузитьВерсиюИзХранилища(Параметры.АдресХранилища, 18, ВерсияИзХранилища, "Администратор");
    Команда.ЗагрузитьКонфигурациюВБазуСборки(УправлениеКонфигуратором, ВерсияИзХранилища);
    
    Команда = Новый КомандаСоздатьФайлыПоставки;
    Команда.СоздатьФайлыКонфигурацииПоставщика(УправлениеКонфигуратором, Параметры.КаталогВерсий, Параметры.ПредыдущиеВерсии);
    
    ФайлКонфигурации = Новый Файл(ОбъединитьПути(КаталогСборки, "1Cv8.cf"));
    Ожидаем.Что(ФайлКонфигурации.Существует(), "Файл конфигурации должен существовать");
    
КонецПроцедуры

Функция ТестовыйМанифест()
    Возврат ТекущийСценарий().Каталог + "/fixtures/package.edf";
КонецФункции

Функция СоздатьТестовыйДистрибутив()
	
    КаталогСборки = ВременныеФайлы.СоздатьКаталог();
    
    Команда = Новый КомандаВыгрузитьИзХранилища;
    УправлениеКонфигуратором = Новый УправлениеКонфигуратором;
    УправлениеКонфигуратором.КаталогСборки(КаталогСборки);
    
    ВерсияИзХранилища = ПолучитьИмяВременногоФайла("cf");
    Команда.ВыгрузитьВерсиюИзХранилища(СоздатьВременноеТестовоеХранилище(), 18, ВерсияИзХранилища, "Администратор");
    Команда.ЗагрузитьКонфигурациюВБазуСборки(УправлениеКонфигуратором, ВерсияИзХранилища);
    
    КомандаФайлыПоставки = Новый КомандаСоздатьФайлыПоставки;
    КомандаФайлыПоставки.СоздатьФайлыКонфигурацииПоставщика(УправлениеКонфигуратором, Неопределено, Новый Массив);
    
    КомандаДистрибутив = Новый КомандаСоздатьДистрибутив;
    КомандаДистрибутив.ВыполнитьСборку(УправлениеКонфигуратором, ТестовыйМанифест(), Истина, Истина, Неопределено);
    
    КаталогДистр = ОбъединитьПути(УправлениеКонфигуратором.КаталогСборки(), ОкружениеСборки.ИмяКаталогаФормированияДистрибутива());

    Возврат КаталогДистр;

КонецФункции

Процедура Тест_ДолженПроверитьЧтоСозданДистрибутив() Экспорт
    
    КаталогДистр = СоздатьТестовыйДистрибутив();
    Ожидаем.Что(Новый Файл(КаталогДистр).Существует());
    Ожидаем.Что(Новый Файл(КаталогДистр+"/setup.exe").Существует());
    
КонецПроцедуры

Процедура Тест_ДолженПроверитьЧтоСозданАрхивДистрибутива() Экспорт
	
	КаталогДистр = СоздатьТестовыйДистрибутив();
    КомандаАрхиватора = Новый КомандаАрхивироватьДистрибутив();
    
    ПараметрыКоманды = Новый Соответствие;
    ПараметрыКоманды["-in"] = КаталогДистр;
    ПараметрыКоманды["-name-prefix"] = "test";
    ПараметрыКоманды["-mdinfo"] = ОбъединитьПути(КаталогДистр,"..");
    ПараметрыКоманды["-out"] = ВременныеФайлы.СоздатьКаталог();

    КомандаАрхиватора.ВыполнитьКоманду(ПараметрыКоманды);

    ФайлыАрхива = НайтиФайлы(ПараметрыКоманды["-out"],"test-?.?.?.?.zip");
    Ожидаем.Что(ФайлыАрхива).ИмеетДлину(1); 

КонецПроцедуры