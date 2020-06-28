class RootView extends View {
    initialize() {
        super.initialize();
        this.style = {
            width: Hummer.env().deviceWidth,
            height: Hummer.env().deviceHeight,
            flexDirection: 'column'
        };

        let text = new Text();
        text.style = {
            marginTop: 30,
            alignSelf: "center",
            width:400,
            height:20
        }
        this.appendChild(text)

        var switchView = new Switch();
        switchView.style = {
            marginTop: 10,
            onColor: "#00ff00",
            offColor: "#999999",
            thumbColor: "#ff0000",
            alignSelf: "center",
        };
        switchView.checked = true;
        switchView.addEventListener('switch', e => {
            if (e.state) text.text = "on 状态";
            else text.text = "off 状态";
        })

        text.text = "on 状态";
        this.appendChild(switchView);
    }
}

Hummer.render(new RootView('rootid'));