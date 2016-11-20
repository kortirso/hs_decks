class AboutBox extends React.Component {

    constructor() {
        super();
        this.state = {
            aboutList: []
        }
    }

    _fetchAboutList() {
        $.ajax({
            method: 'GET',
            url: '/api/v1/about',
            success: (aboutList) => {
                this.setState({aboutList})
            }
        });
    }

    componentWillMount() {
        this._fetchAboutList();
    }

    _prepareAboutList() {
        return this.state.aboutList.map((about) => {
            return (
                <About label={about.label_ru} fixes={about.fixes} key={about.id} />
            );
        });
    }

    render () {
        const about = this._prepareAboutList();
        return (
            <div>
                { about }
            </div>
        );
    }
}

