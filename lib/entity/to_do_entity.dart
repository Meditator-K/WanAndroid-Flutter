class ToDoEntity {
	bool over;
	int pageCount;
	int total;
	int curPage;
	int offset;
	int size;
	List<ToDoData> datas;

	ToDoEntity({this.over, this.pageCount, this.total, this.curPage, this.offset, this.size, this.datas});

	ToDoEntity.fromJson(Map<String, dynamic> json) {
		over = json['over'];
		pageCount = json['pageCount'];
		total = json['total'];
		curPage = json['curPage'];
		offset = json['offset'];
		size = json['size'];
		if (json['datas'] != null) {
			datas = new List<ToDoData>();(json['datas'] as List).forEach((v) { datas.add(new ToDoData.fromJson(v)); });
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['over'] = this.over;
		data['pageCount'] = this.pageCount;
		data['total'] = this.total;
		data['curPage'] = this.curPage;
		data['offset'] = this.offset;
		data['size'] = this.size;
		if (this.datas != null) {
      data['datas'] =  this.datas.map((v) => v.toJson()).toList();
    }
		return data;
	}
}

class ToDoData {
	int date;
	String dateStr;
	int id;
	int priority;
	String title;
	int type;
	int userId;
	String completeDateStr;
	String content;
	int completeDate;
	int status;

	ToDoData({this.date, this.dateStr, this.id, this.priority, this.title, this.type, this.userId, this.completeDateStr, this.content, this.completeDate, this.status});

	ToDoData.fromJson(Map<String, dynamic> json) {
		date = json['date'];
		dateStr = json['dateStr'];
		id = json['id'];
		priority = json['priority'];
		title = json['title'];
		type = json['type'];
		userId = json['userId'];
		completeDateStr = json['completeDateStr'];
		content = json['content'];
		completeDate = json['completeDate'];
		status = json['status'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['date'] = this.date;
		data['dateStr'] = this.dateStr;
		data['id'] = this.id;
		data['priority'] = this.priority;
		data['title'] = this.title;
		data['type'] = this.type;
		data['userId'] = this.userId;
		data['completeDateStr'] = this.completeDateStr;
		data['content'] = this.content;
		data['completeDate'] = this.completeDate;
		data['status'] = this.status;
		return data;
	}
}
