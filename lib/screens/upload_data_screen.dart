// File: lib/screens/upload_data_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadDataScreen extends StatefulWidget {
  const UploadDataScreen({Key? key}) : super(key: key);

  @override
  _UploadDataScreenState createState() => _UploadDataScreenState();
}

class _UploadDataScreenState extends State<UploadDataScreen> {
  bool _isLoading = false;
  String _status = "Klik tombol di bawah untuk mengunggah ratusan soal otomatis.";

  // DATA SESUAI PERMINTAAN ANDA (MULTI-LANGUAGE)
  final List<Map<String, dynamic>> _data = [
    // ---------------- BEGINNER ----------------
    {
      "level": "beginner", "scenario": "airport", "title": "Bandara", "desc": "Skenario di bandara.",
      "questions": [
        {"en": "Say hello to the officer", "ru": "Поздоровайтесь с офицером.", "es": "Saluda al oficial.", "zh": "向官员打招呼。", "answer": "Halo, selamat pagi, Pak."},
        {"en": "Tell them you are going to Jakarta", "ru": "Скажите им, что вы летите в Джакарту.", "es": "Diles que vas a Yakarta.", "zh": "告诉他们你要去雅加达。", "answer": "Saya mau ke Jakarta."},
        {"en": "Say that this is your passport", "ru": "Скажите, что это ваш паспорт.", "es": "Di que este es tu pasaporte.", "zh": "说这是你的护照。", "answer": "Ini paspor saya."},
        {"en": "Ask where gate five is", "ru": "Спросите, где находится выход номер пять.", "es": "Pregunta dónde está la puerta cinco.", "zh": "询问五号登机口在哪里。", "answer": "Di mana gerbang lima?"},
        {"en": "Say thank you very much", "ru": "Скажите большое спасибо.", "es": "Di muchas gracias.", "zh": "说非常感谢。", "answer": "Terima kasih banyak."},
      ]
    },
    {
      "level": "beginner", "scenario": "hotel", "title": "Hotel", "desc": "Skenario di hotel.",
      "questions": [
        {"en": "Say hello in the afternoon", "ru": "Поздоровайтесь во второй половине дня.", "es": "Saluda por la tarde.", "zh": "下午打招呼。", "answer": "Halo, selamat sore."},
        {"en": "Say you want to check-in", "ru": "Скажите, что хотите зарегистрироваться.", "es": "Di que quieres hacer el check-in.", "zh": "说你想办理入住手续。", "answer": "Saya mau check-in."},
        {"en": "Ask for the room key", "ru": "Попросите ключ от номера.", "es": "Pide la llave de la habitación.", "zh": "要求房间钥匙。", "answer": "Boleh minta kunci kamar?"},
        {"en": "Ask them to clean your room", "ru": "Попросите убраться в вашем номере.", "es": "Pídeles que limpien tu habitación.", "zh": "请他们打扫你的房间。", "answer": "Tolong bersihkan kamar saya."},
        {"en": "Say you want to check-out", "ru": "Скажите, что хотите выписаться.", "es": "Di que quieres hacer el check-out.", "zh": "说你想办理退房手续。", "answer": "Saya mau check-out."},
      ]
    },
    {
      "level": "beginner", "scenario": "restaurant", "title": "Restoran", "desc": "Skenario di restoran.",
      "questions": [
        {"en": "Say hello and ask for a table for two", "ru": "Поздоровайтесь и попросите столик на двоих.", "es": "Saluda y pide una mesa para dos.", "zh": "打招呼并要求一张两人桌。", "answer": "Halo, selamat siang. Meja untuk dua orang."},
        {"en": "Say you want fried rice", "ru": "Скажите, что хотите жареный рис.", "es": "Di que quieres arroz frito.", "zh": "说你想要炒饭。", "answer": "Saya mau nasi goreng."},
        {"en": "Ask for iced tea", "ru": "Попросите чай со льдом.", "es": "Pide té con hielo.", "zh": "要一杯冰茶。", "answer": "Minta minum teh es."},
        {"en": "Say you don't want it spicy", "ru": "Скажите, что не хотите острое.", "es": "Di que no lo quieres picante.", "zh": "说你不想要辣的。", "answer": "Jangan pedas, ya."},
        {"en": "Ask for the total price", "ru": "Спросите общую стоимость.", "es": "Pregunta el precio total.", "zh": "询问总价。", "answer": "Berapa harga semuanya, Pak?"},
      ]
    },
    {
      "level": "beginner", "scenario": "market", "title": "Pasar", "desc": "Skenario belanja.",
      "questions": [
        {"en": "Say hello in the morning", "ru": "Поздоровайтесь утром.", "es": "Saluda por la mañana.", "zh": "早上打招呼。", "answer": "Halo, selamat pagi, Bu."},
        {"en": "Ask the price of the apples", "ru": "Спросите цену яблок.", "es": "Pregunta el precio de las manzanas.", "zh": "询问苹果的价格。", "answer": "Apel ini berapa harganya?"},
        {"en": "Ask for one kilogram", "ru": "Попросите один килограмм.", "es": "Pide un kilogramo.", "zh": "要一公斤。", "answer": "Tolong satu kilo saja."},
        {"en": "Ask for a lower price", "ru": "Попросите снизить цену.", "es": "Pide un precio más bajo.", "zh": "要求降低价格。", "answer": "Boleh kurang sedikit harganya?"},
        {"en": "Give money and say thank you", "ru": "Заплатите и поблагодарите.", "es": "Da el dinero y da las gracias.", "zh": "付钱并道谢。", "answer": "Ini uangnya, terima kasih."},
      ]
    },
    {
      "level": "beginner", "scenario": "transportation", "title": "Transportasi", "desc": "Skenario bepergian.",
      "questions": [
        {"en": "Say hello to the driver", "ru": "Поздоровайтесь с водителем.", "es": "Saluda al conductor.", "zh": "向司机打招呼。", "answer": "Halo, selamat pagi, Pak."},
        {"en": "Ask the price to the train station", "ru": "Спросите цену до вокзала.", "es": "Pregunta el precio hasta la estación de tren.", "zh": "询问到火车站的价格。", "answer": "Ke stasiun kereta, berapa?"},
        {"en": "Ask to turn left", "ru": "Попросите повернуть налево.", "es": "Pide girar a la izquierda.", "zh": "要求向左转。", "answer": "Tolong belok kiri di depan."},
        {"en": "Ask to stop here", "ru": "Попросите остановиться здесь.", "es": "Pide parar aquí.", "zh": "要求在这里停车。", "answer": "Berhenti di sini saja, Pak."},
        {"en": "Give money and take change", "ru": "Заплатите и возьмите сдачу.", "es": "Da el dinero y toma el cambio.", "zh": "付钱并找零。", "answer": "Ini uangnya, ambil kembaliannya."},
      ]
    },
    {
      "level": "beginner", "scenario": "clinic", "title": "Klinik", "desc": "Skenario berobat.",
      "questions": [
        {"en": "Say hello in the afternoon", "ru": "Поздоровайтесь во второй половине дня.", "es": "Saluda por la tarde.", "zh": "下午打招呼。", "answer": "Halo, selamat sore, Suster."},
        {"en": "Say your stomach hurts", "ru": "Скажите, что у вас болит живот.", "es": "Di que te duele el estómago.", "zh": "说你的胃很痛。", "answer": "Perut saya sakit sekali."},
        {"en": "Ask if there is a doctor", "ru": "Спросите, есть ли врач.", "es": "Pregunta si hay un médico.", "zh": "询问是否有医生。", "answer": "Ada dokter yang bisa periksa?"},
        {"en": "Ask how to take the medicine", "ru": "Спросите, как принимать лекарство.", "es": "Pregunta cómo tomar el medicamento.", "zh": "询问如何服药。", "answer": "Bagaimana cara minum obat ini?"},
        {"en": "Say thank you very much", "ru": "Скажите большое спасибо.", "es": "Di muchas gracias.", "zh": "说非常感谢。", "answer": "Terima kasih banyak, Suster."},
      ]
    },

    // ---------------- INTERMEDIATE ----------------
    {
      "level": "intermediate", "scenario": "airport", "title": "Bandara", "desc": "Skenario di bandara.",
      "questions": [
        {"en": "Excuse yourself and ask for help", "ru": "Извинитесь и попросите помощи.", "es": "Discúlpate y pide ayuda.", "zh": "打扰一下并请求帮助。", "answer": "Permisi, selamat siang. Bisa bantu saya?"},
        {"en": "Ask for the flight schedule to Jakarta", "ru": "Спросите расписание рейсов в Джакарту.", "es": "Pregunta el horario del vuelo a Yakarta.", "zh": "询问飞往雅加达的航班时刻表。", "answer": "Saya ingin tanya jadwal pesawat ke Jakarta."},
        {"en": "Ask where the baggage claim area is", "ru": "Спросите, где находится зона выдачи багажа.", "es": "Pregunta dónde está la zona de recogida de equipaje.", "zh": "询问行李提取区在哪里。", "answer": "Di mana tempat ambil bagasi pesawat saya?"},
        {"en": "Ask for directions to the taxi stand", "ru": "Попросите указать дорогу к стоянке такси.", "es": "Pide indicaciones para llegar a la parada de taxis.", "zh": "询问去出租车站的方向。", "answer": "Tolong tunjukkan jalan ke pangkalan taksi."},
        {"en": "Thank them for their help", "ru": "Поблагодарите их за помощь.", "es": "Agradéceles su ayuda.", "zh": "感谢他们的帮助。", "answer": "Terima kasih atas bantuannya, Pak."},
      ]
    },
    {
      "level": "intermediate", "scenario": "hotel", "title": "Hotel", "desc": "Skenario di hotel.",
      "questions": [
        {"en": "Say you have booked a room", "ru": "Скажите, что забронировали номер.", "es": "Di que has reservado una habitación.", "zh": "说你已经预订了房间。", "answer": "Selamat sore, saya sudah pesan kamar."},
        {"en": "Ask if breakfast is included", "ru": "Спросите, включён ли завтрак.", "es": "Pregunta si el desayuno está incluido.", "zh": "询问是否包含早餐。", "answer": "Apakah sudah termasuk sarapan besok pagi?"},
        {"en": "Ask for another towel", "ru": "Попросите ещё одно полотенце.", "es": "Pide otra toalla.", "zh": "要求再要一条毛巾。", "answer": "Tolong antarkan satu handuk lagi ke kamar."},
        {"en": "Ask for help turning on the AC", "ru": "Попросите помочь включить кондиционер.", "es": "Pide ayuda para encender el aire acondicionado.", "zh": "请求帮助打开空调。", "answer": "Bisa bantu nyalakan AC di kamar saya?"},
        {"en": "Say you want to check-out and give the key", "ru": "Скажите, что хотите выписаться, и отдайте ключ.", "es": "Di que quieres hacer el check-out y entrega la llave.", "zh": "说你想退房并交出钥匙。", "answer": "Saya mau check-out sekarang, ini kuncinya."},
      ]
    },
    {
      "level": "intermediate", "scenario": "restaurant", "title": "Restoran", "desc": "Skenario di restoran.",
      "questions": [
        {"en": "Ask to book a table", "ru": "Попросите забронировать столик.", "es": "Pide reservar una mesa.", "zh": "要求预订一张桌子。", "answer": "Permisi, selamat siang. Mau pesan meja."},
        {"en": "Ask the best menu", "ru": "Спросите о лучшем блюде.", "es": "Pregunta cuál es el mejor menú.", "zh": "询问最好的菜单。", "answer": "Apa menu makanan yang paling enak di sini?"},
        {"en": "Order chicken satay", "ru": "Закажите куриное сате.", "es": "Pide satay de pollo.", "zh": "点一份鸡肉沙爹。", "answer": "Saya mau pesan satu porsi sate ayam."},
        {"en": "Ask not too spicy", "ru": "Попросите не слишком острое.", "es": "Pide que no esté muy picante.", "zh": "要求不要太辣。", "answer": "Tolong jangan terlalu pedas ya, Mbak."},
        {"en": "Ask for the bill", "ru": "Попросите счёт.", "es": "Pide la cuenta.", "zh": "要求结账。", "answer": "Bisa minta bon atau tagihannya sekarang?"},
      ]
    },
    {
      "level": "intermediate", "scenario": "market", "title": "Pasar", "desc": "Skenario belanja.",
      "questions": [
        {"en": "Ask if the oranges are fresh", "ru": "Спросите, свежие ли апельсины.", "es": "Pregunta si las naranjas son frescas.", "zh": "询问橙子是否新鲜。", "answer": "Selamat pagi Bu, jeruknya masih segar?"},
        {"en": "Ask for discount if buying a lot", "ru": "Спросите о скидке при большой покупке.", "es": "Pregunta por descuento si compras mucho.", "zh": "询问大量购买是否有折扣。", "answer": "Harganya bisa kurang kalau saya beli banyak?"},
        {"en": "Buy two kilos of oranges", "ru": "Купите два килограмма апельсинов.", "es": "Compra dos kilos de naranjas.", "zh": "买两公斤橙子。", "answer": "Saya mau beli dua kilo jeruk manis."},
        {"en": "Ask to pick the best fruits", "ru": "Попросите выбрать лучшие фрукты.", "es": "Pide que escojan las mejores frutas.", "zh": "要求挑选最好的水果。", "answer": "Bisa tolong pilihkan buah yang paling bagus?"},
        {"en": "Say you will come again", "ru": "Скажите, что придёте снова.", "es": "Di que volverás.", "zh": "说你会再来。", "answer": "Terima kasih, Bu. Saya akan datang lagi besok."},
      ]
    },
    {
      "level": "intermediate", "scenario": "transportation", "title": "Transportasi", "desc": "Skenario bepergian.",
      "questions": [
        {"en": "Ask to go to an address", "ru": "Попросите отвезти вас по адресу.", "es": "Pide que te lleven a una dirección.", "zh": "要求去某个地址。", "answer": "Selamat pagi Pak, tolong ke alamat ini."},
        {"en": "Ask travel time", "ru": "Спросите время в пути.", "es": "Pregunta el tiempo de viaje.", "zh": "询问行程时间。", "answer": "Kira-kira berapa lama sampai ke stasiun?"},
        {"en": "Ask to use toll road", "ru": "Попросите поехать по платной дороге.", "es": "Pide usar la autopista de peaje.", "zh": "要求走收费公路。", "answer": "Lewat jalan tol saja supaya tidak macet."},
        {"en": "Ask to stop in front of the gate", "ru": "Попросите остановиться перед воротами.", "es": "Pide parar frente a la puerta.", "zh": "要求在大门前停车。", "answer": "Tolong berhenti tepat di depan gerbang stasiun."},
        {"en": "Thank the driver", "ru": "Поблагодарите водителя.", "es": "Agradece al conductor.", "zh": "感谢司机。", "answer": "Terima kasih Pak, hati-hati di jalan."},
      ]
    },
    {
      "level": "intermediate", "scenario": "clinic", "title": "Klinik", "desc": "Skenario berobat.",
      "questions": [
        {"en": "Say you want to register", "ru": "Скажите, что хотите зарегистрироваться.", "es": "Di que quieres registrarte.", "zh": "说你想挂号。", "answer": "Selamat sore, saya mau daftar periksa."},
        {"en": "Explain your symptoms", "ru": "Опишите ваши симптомы.", "es": "Explica tus síntomas.", "zh": "描述你的症状。", "answer": "Kepala saya pusing dan badan saya demam."},
        {"en": "Ask to buy flu medicine", "ru": "Спросите, можно ли купить лекарство от гриппа.", "es": "Pregunta si puedes comprar medicamento para la gripe.", "zh": "询问是否可以购买感冒药。", "answer": "Apakah saya bisa beli obat flu di sini?"},
        {"en": "Ask how often to take medicine", "ru": "Спросите, как часто принимать лекарство.", "es": "Pregunta con qué frecuencia tomar el medicamento.", "zh": "询问多久服药一次。", "answer": "Berapa kali sehari saya harus minum obat?"},
        {"en": "Thank for the information", "ru": "Поблагодарите за информацию.", "es": "Agradece la información.", "zh": "感谢提供信息。", "answer": "Baik suster, terima kasih atas informasinya."},
      ]
    },

    // ---------------- ADVANCED ----------------
    {
      "level": "expert", "scenario": "airport", "title": "Bandara", "desc": "Skenario di bandara.",
      "questions": [
        {"en": "Ask for help because you are confused", "ru": "Попросите помощи, потому что вы запутались.", "es": "Pide ayuda porque estás confundido.", "zh": "因为困惑 Seah 寻求帮助。", "answer": "Permisi, selamat siang. Bisa bantu saya sebentar karena saya bingung?"},
        {"en": "Ask about delayed flight schedule", "ru": "Спросите о задержанном рейсе.", "es": "Pregunta sobre el vuelo retrasado.", "zh": "询问延误航班的时刻表。", "answer": "Saya ingin tanya jadwal pesawat ke Jakarta yang tadi katanya terlambat."},
        {"en": "Ask baggage claim because you can't find it", "ru": "Спросите о получении багажа, потому что не можете найти.", "es": "Pregunta por el reclamo de equipaje porque no lo encuentras.", "zh": "因为找不到而询问行李提取处。", "answer": "Di mana tempat ambil bagasi pesawat saya karena saya sudah cari tapi tidak ada?"},
        {"en": "Ask for official taxi stand", "ru": "Спросите об официальной стоянке такси.", "es": "Pregunta por la parada de taxis oficial.", "zh": "询问官方出租车站。", "answer": "Tolong tunjukkan jalan ke pangkalan taksi resmi agar saya tidak salah naik."},
        {"en": "Appreciate the help", "ru": "Выразите признательность за помощь.", "es": "Agradece la ayuda.", "zh": "表达对帮助的感激。", "answer": "Terima kasih atas bantuannya, Pak. Saya sangat menghargai informasi ini."},
      ]
    },
    {
      "level": "expert", "scenario": "hotel", "title": "Hotel", "desc": "Skenario di hotel.",
      "questions": [
        {"en": "Say booking under name Budi for two nights", "ru": "Скажите, что бронь на имя Буди на две ночи.", "es": "Di que la reserva está a nombre de Budi por dos noches.", "zh": "说预订是以布迪的名义预订两晚。", "answer": "Selamat sore, saya sudah pesan kamar atas nama Budi untuk dua malam."},
        {"en": "Ask if breakfast included or extra charge", "ru": "Спросите, включён ли завтрак или нужно доплатить.", "es": "Pregunta si el desayuno está incluido o tiene cargo adicional.", "zh": "询问是否含早餐或需要额外收费。", "answer": "Apakah sudah termasuk sarapan besok pagi atau saya harus bayar lagi?"},
        {"en": "Ask for towel because only one available", "ru": "Попросите полотенце, karena ada hanya satu.", "es": "Pide una toalla porque solo hay una disponible.", "zh": "因为只有一条毛巾而要求再要一条。", "answer": "Tolong antarkan satu handuk lagi ke kamar karena di sini hanya ada satu."},
        {"en": "Ask help with broken AC remote", "ru": "Попросите помочь с сломанным пультом от кондиционера.", "es": "Pide ayuda con el control del aire acondicionado que está roto.", "zh": "因为空调遥控器坏了而请求帮助。", "answer": "Bisa bantu nyalakan AC di kamar saya karena sepertinya remotenya rusak?"},
        {"en": "Check-out and ask for bill", "ru": "Выпишитесь и попросите счёт.", "es": "Haz el check-out y pide la cuenta.", "zh": "办理退房并要求账单。", "answer": "Saya mau check-out sekarang, tolong siapkan tagihannya di meja kasir."},
      ]
    },
    {
      "level": "expert", "scenario": "restaurant", "title": "Restoran", "desc": "Skenario di restoran.",
      "questions": [
        {"en": "Book table for birthday event", "ru": "Забронируйте столик для дня рождения.", "es": "Reserva una mesa para un evento de cumpleaños.", "zh": "为生日活动预订桌子。", "answer": "Permisi, selamat siang. Saya mau pesan meja untuk acara ulang tahun."},
        {"en": "Ask best menu for foreign guests", "ru": "Спросите о лучшем меню для иностранных гостей.", "es": "Pregunta cuál es el mejor menú para invitados extranjeros.", "zh": "询问适合外国客人的最佳菜单。", "answer": "Apa menu makanan yang paling enak di sini untuk tamu dari luar negeri?"},
        {"en": "Order satay with sauce separated", "ru": "Закажите сате с соусом отдельно.", "es": "Pide satay con la salsa por separado.", "zh": "点沙爹时要求酱料分开。", "answer": "Saya mau pesan satu porsi sate ayam tapi tolong kacangnya dipisah."},
        {"en": "Not spicy because friend doesn't like it", "ru": "Не острое, потому что другу не нравится острое.", "es": "Sin picante porque a tu amigo no le gusta.", "zh": "不要辣，因为朋友不喜欢辣的。", "answer": "Tolong jangan terlalu pedas ya, Mbak, karena teman saya tidak suka pedas."},
        {"en": "Ask bill and pay by card", "ru": "Попросите счёт и оплатите картой.", "es": "Pide la cuenta y paga con tarjeta.", "zh": "要账单并用卡支付。", "answer": "Bisa minta bon atau tagihannya sekarang? Saya ingin bayar pakai kartu."},
      ]
    },
    {
      "level": "expert", "scenario": "market", "title": "Pasar", "desc": "Skenario belanja.",
      "questions": [
        {"en": "Ask if oranges are fresh or from yesterday", "ru": "Спросите, свежие ли апельсины или со вчера.", "es": "Pregunta si las naranjas son frescas o de ayer.", "zh": "询问橙子是新鲜的还是昨天的存货。", "answer": "Selamat pagi Bu, jeruknya masih segar atau ini stok dari kemarin?"},
        {"en": "Ask discount for stock purchase", "ru": "Спросите скидку при оптовой покупке.", "es": "Pide descuento por compra de stock.", "zh": "询问大量购买存货的折扣。", "answer": "Harganya bisa kurang kalau saya beli banyak untuk stok di rumah?"},
        {"en": "Buy thin-skin oranges", "ru": "Купите апельсины с тонкой кожурой.", "es": "Compra naranjas de piel fina.", "zh": "买皮薄的橙子。", "answer": "Saya mau beli dua kilo jeruk manis yang kulitnya tipis saja."},
        {"en": "Ask for best fruits so they don't rot quickly", "ru": "Попросите лучшие фрукты, чтобы они не гнили быстро.", "es": "Pide las mejores frutas para que no se pudran rápido.", "zh": "要求最好的水果以免很快腐烂。", "answer": "Bisa tolong pilihkan buah yang paling bagus supaya tidak cepat busuk?"},
        {"en": "Say will come again with friend", "ru": "Скажите, что придёте снова с другом.", "es": "Di que volverás con un amigo.", "zh": "说会和朋友再来。", "answer": "Terima kasih, Bu. Saya akan datang lagi besok bersama teman saya."},
      ]
    },
    {
      "level": "expert", "scenario": "transportation", "title": "Transportasi", "desc": "Skenario bepergian.",
      "questions": [
        {"en": "Ask driver to follow map", "ru": "Попросите водителя следовать карте.", "es": "Pide al conductor que siga el mapa.", "zh": "要求司机按照地图走。", "answer": "Selamat pagi Pak, tolong ke alamat ini yang ada di peta."},
        {"en": "Ask travel time in traffic", "ru": "Спросите время в пути с учётом пробок.", "es": "Pregunta el tiempo de viaje con tráfico.", "zh": "询问堵车情况下的行程时间。", "answer": "Kira-kira berapa lama sampai ke stasiun kalau macet seperti sekarang?"},
        {"en": "Ask to take toll because in a hurry", "ru": "Попросите поехать по платной дороге, потому что торопитесь.", "es": "Pide usar el peaje porque tienes prisa.", "zh": "因为赶时间 Seah 要求走收费公路。", "answer": "Lewat jalan tol saja supaya tidak macet karena saya sedang terburu-buru."},
        {"en": "Ask to stop near gate for easy access", "ru": "Попросите остановиться у воrot для удобства.", "es": "Pide parar cerca de la puerta para fácil acceso.", "zh": "要求在大门附近停车以方便进入。", "answer": "Tolong berhenti tepat di depan gerbang stasiun agar saya dekat berjalan."},
        {"en": "Thank and mention rainy weather", "ru": "Поблагодарите и упомяните дождливую погоду.", "es": "Agradece y menciona el tiempo lluvioso.", "zh": "感谢并提到雨天。", "answer": "Terima kasih Pak, hati-hati di jalan karena cuaca sedang hujan."},
      ]
    },
    {
      "level": "expert", "scenario": "clinic", "title": "Klinik", "desc": "Skenario berobat.",
      "questions": [
        {"en": "Register for general doctor", "ru": "Запишитесь к врачу общей практики.", "es": "Regístrate para el médico general.", "zh": "挂一般科医生的号。", "answer": "Selamat sore, saya mau daftar periksa untuk dokter umum sekarang."},
        {"en": "Explain symptoms since last night", "ru": "Опишите симптомы, начавшиеся прошлой ночью.", "es": "Explica los síntomas desde anoche.", "zh": "解释从昨晚开始的症状。", "answer": "Kepala saya pusing dan badan saya demam sejak tadi malam."},
        {"en": "Ask to buy medicine without prescription", "ru": "Спросите, можно ли купить лекарство без рецепта.", "es": "Pregunta si puedes comprar medicamento sin receta.", "zh": "询问是否可以不凭处方购买药物。", "answer": "Apakah saya bisa beli obat flu di sini tanpa resep dokter?"},
        {"en": "Ask dosage for faster recovery", "ru": "Спросите дозировку для более быстрого выздоровления.", "es": "Pregunta la dosis para recuperarte más rápido.", "zh": "询问剂量以便更快康复。", "answer": "Berapa kali sehari saya harus minum obat agar cepat sembuh?"},
        {"en": "Thank and wait", "ru": "Поблагодарите и подождите.", "es": "Agradece y espera.", "zh": "感谢并等待。", "answer": "Baik suster, terima kasih atas informasinya. Saya tunggu di ruang tamu."},
      ]
    },
  ];

  Future<void> _uploadAllData() async {
    setState(() {
      _isLoading = true;
      _status = "Memulai proses unggah ratusan soal ke Firestore...";
    });

    try {
      final firestore = FirebaseFirestore.instance;
      
      for (var group in _data) {
        String level = group['level'];
        String scenarioKey = group['scenario'];
        
        // Document ID menggunakan format level_scenario (misal: beginner_airport)
        String docId = '${level}_$scenarioKey';
        DocumentReference topicRef = firestore.collection('topics').doc(docId);
        
        await topicRef.set({
          'level': level,
          'scenario': scenarioKey,
          'title': group['title'],
          'description': group['desc'],
        }, SetOptions(merge: true));

        // Masukkan semua pertanyaan ke sub-koleksi 'items'
        List<Map<String, dynamic>> questions = group['questions'];
        for (int i = 0; i < questions.length; i++) {
          String qId = '${scenarioKey}_${level}_$i'; 
          await topicRef.collection('items').doc(qId).set({
            'audioUrl': questions[i]['audioUrl'] ?? "",
            'question': {
              'en': questions[i]['en'],
              'ru': questions[i]['ru'],
              'es': questions[i]['es'],
              'zh': questions[i]['zh'],
            },
            'answer': questions[i]['answer'], // Bahasa Indonesia
          });
        }
      }

      setState(() {
        _status = "BERHASIL! Data multi-bahasa berhasil diunggah.";
      });
    } catch (e) {
      setState(() {
        _status = "ERROR: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Skema Soal Multi-Bahasa")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_upload_outlined, size: 80, color: Colors.blue[400]),
              const SizedBox(height: 20),
              Text(
                _status,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 40),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton.icon(
                  onPressed: _uploadAllData,
                  icon: const Icon(Icons.upload),
                  label: const Text("Suntik Semua Soal Ke Firestore", style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
