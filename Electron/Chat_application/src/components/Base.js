import React from 'react';


export default class Room extends React.Component{
    componentDidMount() {
        try {
            const json = localStorage.getItem('options');
            const options = JSON.parse(json);

            if (options) {
            this.setState(() => ({ options }));
            }
        } catch (e) {
            // Do nothing at all
        }
    }
    
    render() {
        return (
            <div>
                <h3>Room</h3>
            </div>
        )
    }
}