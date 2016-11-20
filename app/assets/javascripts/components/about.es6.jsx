class About extends React.Component {

    constructor() {
        super();
        this.state = {
            fixList: []
        }
    }

    _fetchFixList() {
        this.setState({ fixList: this.props.fixes })
    }

    componentWillMount() {
        this._fetchFixList();
    }

    _prepareFixList() {
        return this.state.fixList.map((fix) => {
            return (
                <li key={fix.id}>{ fix[`body_${this.props.locale}`] }</li>
            );
        });
    }

    render () {
        const fixes = this._prepareFixList();
        return (
            <div>
                <h5>{this.props.label}</h5>
                { fixes }
            </div>
        );
    }
}
