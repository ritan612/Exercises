import { LightningElement, wire } from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
import { gql, graphql } from 'lightning/uiGraphQLApi';
import Id from '@salesforce/user/Id';

export default class Welcome extends NavigationMixin(LightningElement) {
    userId = Id;
    userName;
    userBanner;
    userLogo;
    errors;

    @wire(graphql, {
        query: gql`
            query GetUser($userId: ID!) {
                uiapi {
                    query {
                        User(where: { Id: { eq: $userId } }) {
                            edges {
                                node {
                                    Name {
                                        value
                                    }
                                    BannerPhotoUrl{
                                        value
                                    }
                                    FullPhotoUrl{
                                        value
                                    }
                                }
                            }
                        }
                    }
                }
            }
        `,
        variables: '$graphqlVariables'
    })
    graphqlQueryResult({ data, errors }) {
        if (data) {
            const edges = data.uiapi.query.User?.edges;
            if (edges && edges.length > 0) {
                this.userName = edges[0].node.Name.value;
                this.userBanner = edges[0].node.BannerPhotoUrl.value;
                this.userLogo = edges[0].node.FullPhotoUrl.value;
            }
        }
        if (errors) {
            this.errors = errors;
            console.error('GraphQL Errors:', JSON.stringify(errors));
        }
    }

    get graphqlVariables() {
        return {
            userId: this.userId
        };
    }

    get timeOfDayGreeting() {
        const hour = new Date().getHours();
        if (hour < 12) {
            return 'Good morning';
        } else if (hour < 18) {
            return 'Good afternoon';
        }
        return 'Good evening';
    }

    get fullGreeting() {
        return this.userName ? `${this.timeOfDayGreeting}, ${this.userName}!` : `${this.timeOfDayGreeting}!`;
    }

     navigateToTask() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Task',
                actionName: 'list'
            },
            state: {
                filterName: '00Bg500000KsFxpEAF' 
            }
        });
    }

}